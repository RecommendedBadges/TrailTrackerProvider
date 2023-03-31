public without sharing class BadgeTriggerHandler extends TriggerHandler {
    public BadgeTriggerHandler() {
        super();
    }

    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
       publishUpdateEvents(updatedRecordsMap, oldRecordsMap);
    }

    public static void publishUpdateEvents(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
        String namespacePrefix = 'trailheadapp__'; // todo - make more dynamic

        Map<String, Schema.SObjectField> updateEventFieldsMap = Schema.TrailheadEntityUpdateEvent__e.sObjectType.getDescribe().fields.getMap();
        List<String> customUpdateEventFields = new List<String>();
        for(String fieldName : updateEventFieldsMap.keySet()) {
            if(fieldName.contains('__c')) customUpdateEventFields.add(fieldName);
        }
        // play around with heap size to see difference maybe? ... well we'd probably have to run tests for that. not sure if i care *that* much
        
        List<TrailheadEntityUpdateEvent__e> updateEvents = new List<TrailheadEntityUpdateEvent__e>();
        for(sObject updatedRecord : updatedRecordsMap.values()) {
            TrailheadEntityUpdateEvent__e updateEvent = new TrailheadEntityUpdateEvent__e();
            for(String customUpdateEventField : customUpdateEventFields) {
                sObject oldRecord = oldRecordsMap.get(String.valueOf(updatedRecord.get('Id')));
                Object newFieldValue = getNewFieldValue(updatedRecord, oldRecord, customUpdateEventField, namespacePrefix);
                if(newFieldValue != null) {
                    updateEvent.put(customUpdateEventField, newFieldValue);
                }
            }
            if(updateEvent != new TrailheadEntityUpdateEvent__e()) {
                updateEvents.add(updateEvent);
            }
        }

        EventBus.publish(updateEvents);
        // separate method for if field has changed
        // need to figure out the fields that we care about
        // need to have namespace prefix
        // bulkified => need some loops, have to work through how many should be nested
        
    }

    public static Object getNewFieldValue(sObject updatedRecord, sObject oldRecord, String fieldName, String namespacePrefix) {
        if(updatedRecord.get(namespacePrefix + fieldName) != oldRecord.get(namespacePrefix + fieldName)) {
            return updatedRecord.get(namespacePrefix + fieldName);
        }
        return null;
        /*
            field types...
            archived => checkbox
            description => long text area
            icon => text
            level => text
            name => text
            products => long text area
            type => text
            url => text
        */
    }
    // create platform events with changed formula/picklist fields, changed values, and record ids/external ids
    // can this be a ..... service? not sure (update: probably not)
    // should namespace prefix be a lazy loaded static variable? that's a question for later
}