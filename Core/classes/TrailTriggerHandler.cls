/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 06-02-2023
 * @last modified by  : Ben Learn
**/
public without sharing class TrailTriggerHandler  extends TriggerHandler {
    public TrailTriggerHandler() {
        super();
    }

    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
        new TrailheadEntities(updatedRecordsMap, oldRecordsMap, 'trailheadapp__Trail__c').publishUpdateEvents();
    }
}