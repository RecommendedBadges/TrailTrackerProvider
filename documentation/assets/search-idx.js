export default [
    {
        "title": "Home",
        "fileName": "index.html",
        "text": "Home hello"
    },
    {
        "title": "BadgeTriggerHandler",
        "fileName": "BadgeTriggerHandler.html",
        "text": "BadgeTriggerHandler : Signature public without sharing class BadgeTriggerHandler extends TriggerHandler Author : Ben Learn BadgeTriggerHandler Constructors BadgeTriggerHandler() BadgeTriggerHandler() Signature public BadgeTriggerHandler() BadgeTriggerHandler Methods afterUpdate(updatedRecordsMap, oldRecordsMap) afterUpdate(updatedRecordsMap, oldRecordsMap) Signature protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap)"
    },
    {
        "title": "TrailTriggerHandler",
        "fileName": "TrailTriggerHandler.html",
        "text": "TrailTriggerHandler : Signature public without sharing class TrailTriggerHandler  extends TriggerHandler Author : Ben Learn TrailTriggerHandler Constructors TrailTriggerHandler() TrailTriggerHandler() Signature public TrailTriggerHandler() TrailTriggerHandler Methods afterUpdate(updatedRecordsMap, oldRecordsMap) afterUpdate(updatedRecordsMap, oldRecordsMap) Signature protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap)"
    },
    {
        "title": "TrailheadEntities",
        "fileName": "TrailheadEntities.html",
        "text": "TrailheadEntities : Signature public inherited sharing class TrailheadEntities Author : Ben Learn TrailheadEntities Properties Name Signature entityType private String entityType namespacePrefix private String namespacePrefix oldRecordsMap private Map<Id, sObject> oldRecordsMap trackedFieldsByObject private static Map<String, List<String>> trackedFieldsByObject updatedRecordsMap private Map<Id, sObject> updatedRecordsMap TrailheadEntities Constructors TrailheadEntities(updatedRecordsMap, oldRecordsMap, entityType) TrailheadEntities(updatedRecordsMap, oldRecordsMap, entityType) Signature public TrailheadEntities(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap, String entityType) TrailheadEntities Methods getValueIfChanged(updatedRecord, oldRecord, fieldName) publishUpdateEvents() getValueIfChanged(updatedRecord, oldRecord, fieldName) Signature private static Object getValueIfChanged(sObject updatedRecord, sObject oldRecord, String fieldName) publishUpdateEvents() Signature public void publishUpdateEvents()"
    },
    {
        "title": "TrailheadEntityUpdateEventTriggerHandler",
        "fileName": "TrailheadEntityUpdateEventTriggerHandler.html",
        "text": "TrailheadEntityUpdateEventTriggerHandler Trigger handler for the TrailheadEntityUpdateEvent__e platform event Signature public without sharing class TrailheadEntityUpdateEventTriggerHandler extends TriggerHandler Author Ben Learn Since 06-02-2023 TrailheadEntityUpdateEventTriggerHandler Constructors TrailheadEntityUpdateEventTriggerHandler() TrailheadEntityUpdateEventTriggerHandler() Signature public TrailheadEntityUpdateEventTriggerHandler() TrailheadEntityUpdateEventTriggerHandler Methods afterInsert(newRecordsMap) afterInsert(newRecordsMap) Signature protected override void afterInsert(Map<Id, sObject> newRecordsMap) Parameters newRecordsMap Type: Map<Id, sObject>"
    }
];
