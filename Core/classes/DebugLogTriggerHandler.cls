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
    private static Boolean scheduledBatch = false;
    
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
            if((syncJobIsFinished(debugLog) == true) && (numTrailheadEntityUpdates > 0) && (scheduledBatch == false)) {
                System.scheduleBatch(new BatchTrailheadEntityUpdateSync(), 'BatchTrailheadEntityUpdateSync', 5, 200);
                scheduledBatch = true;
            }
        }
    }

    private static Boolean syncJobIsFinished(sObject record) {
        trailheadapp__Debug_Log__c debugLog = (trailheadapp__Debug_Log__c) record;
        if(
            (debugLog.trailheadapp__Class__c == SYNC_FINISHED_CLASS) && (debugLog.trailheadapp__Method__c == SYNC_FINISHED_METHOD) && 
            (debugLog.trailheadapp__Message__c == SYNC_FINISHED_MESSAGE) && (debugLog.trailheadapp__Severity__c == SYNC_FINISHED_SEVERITY)
         ) {
            return true;
        }
        return false;
    }
}