/**
 * Trigger handler for trailheadapp__Badge__c custom object
 * @author Ben Learn
 * @since 06-01-2023
 * @group Core
**/
public without sharing class BadgeTriggerHandler extends TriggerHandler {
    public BadgeTriggerHandler() {
        super();
    }

    /**
     * 
     * @param updatedRecordsMap Map of IDs to updated trailheadapp__Badge__c records
     * @param oldRecordsMap Map of IDs to old trailheadapp__Badge__c records
     */    
    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
       EventBus.publish(new TrailheadEntities(updatedRecordsMap, oldRecordsMap, 'trailheadapp__Badge__c').generateUpdateEvents());
    }
}