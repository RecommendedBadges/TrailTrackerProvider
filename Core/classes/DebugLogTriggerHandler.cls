/**
 * Trigger handler for the trailheadapp__Debug_Log__c custom object
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class DebugLogTriggerHandler extends TriggerHandler {
    private static Boolean scheduledDeleteSync = false;
    private static Boolean scheduledUpdateSync = false;

    private class WatchedClass {
        private String className;
        private String methodName;
        private String messagePattern;
        private String severity;

        private WatchedClass(String className, String methodName, String messagePattern, String severity) {
            this.className = className;
            this.methodName = methodName;
            this.messagePattern = messagePattern;
            this.severity = severity;
        }
    }

    private static final Map<String, WatchedClass> WATCHED_CLASSES {
        get {
            if(WATCHED_CLASSES == null) {
                WATCHED_CLASSES = new Map<String, WatchedClass>{
                    'Badge' => new WatchedClass('Badge', 'upsertBadges', 'Upserted \\d{4} Badge records.', 'INFO'),
                    'Trail' => new WatchedClass('Trail', 'upsertTrails', 'Upserted \\d{3} Trail records.', 'INFO'),
                    'TrailheadSync' => new WatchedClass('TrailheadSync', 'start', 'Processing \\d{2} Trailmix records.', 'INFO')
                };
            }
            return WATCHED_CLASSES;
        }
        set;
    }
    
    /**
     * Constructor for trigger handler
     */
    public DebugLogTriggerHandler() {
        super();
    }

    /**
     * 
     * @param newRecordsMap Map of IDs to newly inserted trailheadapp__Debug_Log__c records
     */    
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        Integer numTrailheadEntityUpdates = [SELECT COUNT() FROM TrailheadEntityUpdate__c];
        Integer numTrailheadEntityDeletes = [SELECT COUNT() FROM TrailheadEntityDelete__c];

        Boolean badgeSyncFinished = false;
        Boolean trailSyncFinished = false;
        List<StorageEvent__e> storageEvents = new List<StorageEvent__e>();

        for(sObject debugLog : newRecordsMap.values()) {
            if(watchedClass((trailheadapp__Debug_Log__c) debugLog) == true) {
                switch on String.valueOf(debugLog.get('trailheadapp__Class__c')) {
                    when 'Badge' {
                        storageEvents.add(new StorageEvent__e(
                            Action__c = 'delete',
                            ConditionField__c = 'trailheadapp__Archived__c',
                            ConditionOperator__c = '=',
                            ConditionValue__c = 'true',
                            Object__c = 'trailheadapp__Badge__c'
                        ));
                        badgeSyncFinished = true;
                    } when 'Trail' {
                        storageEvents.add(new StorageEvent__e(
                            Action__c = 'delete',
                            ConditionField__c = 'trailheadapp__Archived__c',
                            ConditionOperator__c = '=',
                            ConditionValue__c = 'true',
                            Object__c = 'trailheadapp__Trail__c'
                        ));
                        trailSyncFinished = true;
                    } when 'TrailheadSync' {
                        storageEvents.add(new StorageEvent__e(
                            Action__c = 'delete',
                            Object__c = 'trailheadapp__Trailmix__c'
                        ));
                    }
                }
            }
        }

        if(badgeSyncFinished && trailSyncFinished) {
            if((numTrailheadEntityUpdates > 0) && (scheduledUpdateSync == false)) {
                System.scheduleBatch(new BatchTrailheadEntityUpdateSync(), 'BatchTrailheadEntityUpdateSync', 5, 200);
                scheduledUpdateSync = true;
            }
            if((numTrailheadEntityDeletes > 0) && (scheduledDeleteSync == false)) {
                System.scheduleBatch(new BatchTrailheadEntityDeleteSync(), 'BatchTrailheadEntityDeleteSync', 5, 200);
                scheduledDeleteSync = true;
            }
        }

        if(storageEvents.size() > 0) {
            List<Database.SaveResult> saveResults = EventBus.publish(storageEvents);
            DMLUtils.logErrors(saveResults, 'DebugLogTriggerHandler');
        }
    }

    private static Boolean watchedClass(trailheadapp__Debug_Log__c debugLog) {
        if(WATCHED_CLASSES.containsKey(debugLog.trailheadapp__Class__c)) {
            WatchedClass wc = WATCHED_CLASSES.get(debugLog.trailheadapp__Class__c);
            if(
                (debugLog.trailheadapp__Method__c == wc.methodName) && Pattern.matches(wc.messagePattern, debugLog.trailheadapp__Message__c) && 
                (debugLog.trailheadapp__Severity__c == wc.severity)
            ) {
                return true;
            }
        }
        return false;
    }
}