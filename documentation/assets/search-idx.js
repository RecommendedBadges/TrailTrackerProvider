export default [
    {
        "title": "Home",
        "fileName": "index.html",
        "text": "Home Trail Tracker Provider Check out the Recommended Badges wiki !"
    },
    {
        "title": "BadgeTriggerHandler",
        "fileName": "BadgeTriggerHandler.html",
        "text": "BadgeTriggerHandler Trigger handler for trailheadapp__Badge__c custom object Signature public without sharing class BadgeTriggerHandler extends TriggerHandler Author Ben Learn Since 06-01-2023 BadgeTriggerHandler Constructors BadgeTriggerHandler() Constructor for trigger handler BadgeTriggerHandler() Constructor for trigger handler Signature public BadgeTriggerHandler() BadgeTriggerHandler Methods afterUpdate(updatedRecordsMap, oldRecordsMap) afterUpdate(updatedRecordsMap, oldRecordsMap) Signature protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) Parameters updatedRecordsMap Type: Map<Id, sObject> Map of IDs to updated trailheadapp__Badge__c records oldRecordsMap Type: Map<Id, sObject> Map of IDs to old trailheadapp__Badge__c records"
    },
    {
        "title": "DebugLogTriggerHandler",
        "fileName": "DebugLogTriggerHandler.html",
        "text": "DebugLogTriggerHandler Trigger handler for the trailheadapp__Debug_Log__c custom object Signature public without sharing class DebugLogTriggerHandler extends TriggerHandler Author Ben Learn Since 06-02-2023 DebugLogTriggerHandler Constructors DebugLogTriggerHandler() Constructor for trigger handler DebugLogTriggerHandler() Constructor for trigger handler Signature public DebugLogTriggerHandler() DebugLogTriggerHandler Methods afterInsert(newRecordsMap) afterInsert(newRecordsMap) Signature protected override void afterInsert(Map<Id, sObject> newRecordsMap) Parameters newRecordsMap Type: Map<Id, sObject> Map of IDs to newly inserted trailheadapp__Debug_Log__c records"
    },
    {
        "title": "TrailTriggerHandler",
        "fileName": "TrailTriggerHandler.html",
        "text": "TrailTriggerHandler Trigger handler for trailheadapp__Trail__c custom object Signature public without sharing class TrailTriggerHandler  extends TriggerHandler Author Ben Learn Since 06-02-2023 TrailTriggerHandler Constructors TrailTriggerHandler() Constructor for trigger handler TrailTriggerHandler() Constructor for trigger handler Signature public TrailTriggerHandler() TrailTriggerHandler Methods afterUpdate(updatedRecordsMap, oldRecordsMap) afterUpdate(updatedRecordsMap, oldRecordsMap) Signature protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) Parameters updatedRecordsMap Type: Map<Id, sObject> Map of IDs to updated trailheadapp__Trail__c records oldRecordsMap Type: Map<Id, sObject> Map of IDs to old trailheadapp__Trail__c records"
    },
    {
        "title": "TrailheadEntities",
        "fileName": "TrailheadEntities.html",
        "text": "TrailheadEntities Domain class for functionality shared between the trailheadapp__Badge__c and trailheadapp__Trail__c custom objects Signature public inherited sharing class TrailheadEntities Author Ben Learn Since 06-02-2023 TrailheadEntities Constructors TrailheadEntities(updatedRecordsMap, oldRecordsMap, entityType) TrailheadEntities(updatedRecordsMap, oldRecordsMap, entityType) Signature @SuppressWarnings('PMD.ApexDoc') public TrailheadEntities(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap, String entityType) TrailheadEntities Methods generateUpdateEvents() Publishes TrailheadEntityUpdateEvent__e platform events for changes to tracked fields on badges and trails. generateUpdateEvents() Publishes TrailheadEntityUpdateEvent__e platform events for changes to tracked fields on badges and trails. Signature public List<TrailheadEntityUpdateEvent__e> generateUpdateEvents() Returns List<TrailheadEntityUpdateEvent__e>"
    },
    {
        "title": "TrailheadEntityUpdateEventTriggerHandler",
        "fileName": "TrailheadEntityUpdateEventTriggerHandler.html",
        "text": "TrailheadEntityUpdateEventTriggerHandler Trigger handler for the TrailheadEntityUpdateEvent__e platform event Signature public without sharing class TrailheadEntityUpdateEventTriggerHandler extends TriggerHandler Author Ben Learn Since 06-02-2023 TrailheadEntityUpdateEventTriggerHandler Constructors TrailheadEntityUpdateEventTriggerHandler() Constructor for trigger handler TrailheadEntityUpdateEventTriggerHandler() Constructor for trigger handler Signature public TrailheadEntityUpdateEventTriggerHandler() TrailheadEntityUpdateEventTriggerHandler Methods afterInsert(newRecordsMap) afterInsert(newRecordsMap) Signature protected override void afterInsert(Map<Id, sObject> newRecordsMap) Parameters newRecordsMap Type: Map<Id, sObject> Map of IDs to newly inserted TrailheadEntityUpdateEvent__e events"
    }
];
