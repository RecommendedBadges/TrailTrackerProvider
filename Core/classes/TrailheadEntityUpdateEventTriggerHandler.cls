/**
 * Trigger handler for the TrailheadEntityUpdateEvent__e platform event
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class TrailheadEntityUpdateEventTriggerHandler extends TriggerHandler {
    public TrailheadEntityUpdateEventTriggerHandler() {
        super();
    }
    /**
     * 
     * @param newRecordsMap Map of IDs to newly inserted TrailheadEntityUpdateEvent__e events
     */
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        
    }
}