/**
 * Trigger handler for the trailheadapp__Debug_Log__c custom object
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class DebugLogTriggerHandler extends TriggerHandler {
    @TestVisible
    private static final String SYNC_FINISHED_CLASS = 'TrailheadSync';
    @TestVisible
    private static final String	SYNC_FINISHED_METHOD = 'finish';
    @TestVisible
    private static final String SYNC_FINISHED_MESSAGE = 'Finished Trail Tracker sync.';
    @TestVisible
    private static final String SYNC_FINISHED_SEVERITY = 'INFO';

    private static Boolean scheduledDeleteSync = false;
    private static Boolean scheduledUpdateSync = false;

    private class WatchedClass {
        private String className;
        private String methodName;
        private String messageStart;
        private String messageEnd;
        private String severity;

        private WatchedClass(String className, String methodName, String messageStart, String messageEnd, String severity) {
            this.className = className;
            this.methodName = methodName;
            this.messageStart = messageStart;
            this.messageEnd = messageEnd;
            this.severity = severity;
        }
    }

    private static Map<String, WatchedClass> watchedClasses {
        get {
            if(watchedClasses == null) {
                watchedClasses = new Map<String, WatchedClass>();
                watchedClasses.put('Badge', new WatchedClass('Badge', 'upsertBadges', 'Upserted', 'Badge records.', 'INFO'));
                watchedClasses.put('Trail', new WatchedClass('Trail', 'upsertTrails', 'Upserted', 'Trail records.', 'INFO'));
                watchedClasses.put('TrailheadSync', new WatchedClass('TrailheadSync', 'start', 'Processing', 'Trailmix records.', 'INFO'));
            }
            return watchedClasses;
        }
        set;
    }

    private static Boolean watchedBadgeDebugLog;
    private static Boolean watchedTrailDebugLog;
    private static Boolean watchedTrailmixDebugLog;
    
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
        for(sObject debugLog : newRecordsMap.values()) {
            if((syncJobIsFinished((trailheadapp__Debug_Log__c) debugLog)) == true) {
                if((numTrailheadEntityUpdates > 0) && (scheduledUpdateSync == false)) {
                    System.scheduleBatch(new BatchTrailheadEntityUpdateSync(), 'BatchTrailheadEntityUpdateSync', 5, 200);
                    scheduledUpdateSync = true;
                }
                if((numTrailheadEntityDeletes > 0) && (scheduledDeleteSync == false)) {
                    System.scheduleBatch(new BatchTrailheadEntityDeleteSync(), 'BatchTrailheadEntityDeleteSync', 5, 200);
                    scheduledDeleteSync = true;
                }
            }

            if(watchedClass((trailheadapp__Debug_Log__c) debugLog) == true) {
                switch on String.valueOf(debugLog.get('trailheadapp__Class__c')) {
                    when 'Badge' {
                        watchedBadgeDebugLog = true;
                    } when 'Trail' {
                        watchedTrailDebugLog = true;
                    } when 'TrailheadSync' {
                        watchedTrailmixDebugLog = true;
                    }
                }
            }
        }
        Logger.info(new LogMessage(
            'Debug log for loop completed. watchedBadgeDebugLog is {0}. watchedTrailDebugLog is {1}. watchedTrailmixDebugLog is {2}.', 
            watchedBadgeDebugLog,
            watchedTrailDebugLog,
            watchedTrailmixDebugLog
        ));
        Logger.saveLog();
    }

    private static Boolean syncJobIsFinished(trailheadapp__Debug_Log__c debugLog) {
        if(
            (debugLog.trailheadapp__Class__c == SYNC_FINISHED_CLASS) && (debugLog.trailheadapp__Method__c == SYNC_FINISHED_METHOD) && 
            (debugLog.trailheadapp__Message__c == SYNC_FINISHED_MESSAGE) && (debugLog.trailheadapp__Severity__c == SYNC_FINISHED_SEVERITY)
         ) {
            return true;
        }
        return false;
    }

    private static Boolean watchedClass(trailheadapp__Debug_Log__c debugLog) {
        Boolean isWatched = false;
        if(watchedClasses.containsKey(debugLog.trailheadapp__Class__c)) {
            WatchedClass wc = watchedClasses.get(debugLog.trailheadapp__Class__c);
            if(
                (debugLog.trailheadapp__Method__c == wc.methodName) && debugLog.trailheadapp__Message__c.startsWith(wc.messageStart) && 
                debugLog.trailheadapp__Message__c.endsWith(wc.messageEnd) && (debugLog.trailheadapp__Severity__c == wc.severity)
            ) {
                isWatched = true;
            }
        }
        return isWatched;
    }
}