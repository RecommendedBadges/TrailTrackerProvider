/**
 * Trigger handler for trailheadapp__Trail__c custom object
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
**/
public without sharing class TrailTriggerHandler  extends TriggerHandler {    
    /**
     * Constructor for trigger handler
    */
    public TrailTriggerHandler() {
        super();
    }

    /**
     * 
     * @param updatedRecordsMap Map of IDs to updated trailheadapp__Trail__c records
     * @param oldRecordsMap Map of IDs to old trailheadapp__Trail__c records
     */
    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
        List<Database.SaveResult> publishResults = EventBus.publish(
            new TrailheadEntities(updatedRecordsMap, oldRecordsMap, Schema.SObjectType.trailheadapp__Trail__c.getName()).generateTrailheadEntityEvents()
        );
        DMLUtils.logErrors(publishResults, 'TrailTriggerHandler');
    }
}