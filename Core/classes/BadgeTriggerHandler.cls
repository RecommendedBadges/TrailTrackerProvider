/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 06-01-2023
 * @last modified by  : Ben Learn
**/
public without sharing class BadgeTriggerHandler extends TriggerHandler {
    public BadgeTriggerHandler() {
        super();
    }

    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
       new TrailheadEntities(updatedRecordsMap, oldRecordsMap, 'trailheadapp__Badge__c').publishUpdateEvents();
    }
}