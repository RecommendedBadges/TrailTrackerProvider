/**
 * Trigger handler for the trailheadapp__Debug_Log__c custom object
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class DebugLogTriggerHandler extends TriggerHandler {
    private static final String SYNC_FINISHED_CLASS = 'TrailheadSync';
    private static final String	SYNC_FINISHED_METHOD = 'finish';
    private static final String SYNC_FINISHED_MESSAGE = 'Finished Trail Tracker sync.';
    private static final String SYNC_FINISHED_SEVERITY = 'INFO';

    public DebugLogTriggerHandler() {
        super();
    }

    /**
     * 
     * @param newRecordsMap Map of IDs to newly inserted trailheadapp__Debug_Log__c records
     */    
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        Integer numTrailheadEntityUpdateRecords = [SELECT COUNT() FROM TrailheadEntityUpdate__c];
        for(sObject debugLog : newRecordsMap.values()) {
            if((syncJobIsFinished(debugLog) == true) && (numTrailheadEntityUpdateRecords > 0)) {
                // enqueue job that makes callout
                // maybe add a check here to see if there are any trailheadentityupdate records

    /*
    Queues async job to make callout to subscriber
    with IDs of custom object records.
    */
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