/**
 * Trigger handler for trailheadapp__Badge__c custom object
 * @author Ben Learn
 * @since 06-01-2023
 * @group Core
**/
public without sharing class BadgeTriggerHandler extends TriggerHandler {    
    /**
     * Constructor for trigger handler
     */
    public BadgeTriggerHandler() {
        super();
    }

    /**
     * 
     * @param updatedRecordsMap Map of IDs to updated trailheadapp__Badge__c records
     * @param oldRecordsMap Map of IDs to old trailheadapp__Badge__c records
     */    
    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
        List<Database.SaveResult> publishResults = EventBus.publish(
                new TrailheadEntities(updatedRecordsMap, oldRecordsMap, Schema.SObjectType.trailheadapp__Badge__c.getName()).generateTrailheadEntityEvents()
        );
        DMLUtils.logErrors(publishResults, 'BadgeTriggerHandler');
    }
}