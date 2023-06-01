/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 06-01-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class TrailheadEntities {
    private static Map<String, List<String>> trackedFieldsByObject {
        get {
            if(trackedFieldsByObject == null) {
                List<TrackedField__mdt> trackedFields = [SELECT DeveloperName, Field__r.QualifiedApiName, Object__r.QualifiedApiName FROM TrackedField__mdt];
                trackedFieldsByObject = new Map<String, List<String>>();
                for(TrackedField__mdt tf : trackedFields) {
                    if(trackedFieldsByObject.get(tf.Object__r.QualifiedApiName) == null) {
                        trackedFieldsByObject.put(tf.Object__r.QualifiedApiName, new List<String>{tf.Field__r.QualifiedApiName});
                    } else {
                        List<String> tempTrackedFields = trackedFieldsByObject.get(tf.Object__r.QualifiedApiName);
                        tempTrackedFields.add(tf.Field__r.QualifiedApiName);
                        trackedFieldsByObject.put(tf.Object__r.QualifiedApiName, tempTrackedFields);
                    }
                }
            }
            return trackedFieldsByObject;
        } set {
            trackedFieldsByObject = value;
        }
    }

    private Map<Id, sObject> updatedRecordsMap;
    private Map<Id, sObject> oldRecordsMap;
    private String entityType;

    public TrailheadEntities(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap, String entityType) {
        this.updatedRecordsMap = updatedRecordsMap;
        this.oldRecordsMap = oldRecordsMap;
        this.entityType = entityType;
    }

    public void publishUpdateEvents() {
        String namespacePrefix = 'trailheadapp__'; // todo - make more dynamic - might be obselete now

        System.debug(trackedFieldsByObject);

        
        List<TrailheadEntityUpdateEvent__e> updateEvents = new List<TrailheadEntityUpdateEvent__e>();
        for(sObject updatedRecord : updatedRecordsMap.values()) {
            TrailheadEntityUpdateEvent__e updateEvent = new TrailheadEntityUpdateEvent__e();
            for(String trackedField : trackedFieldsByObject.get(this.entityType)) {
                // updating here
                sObject oldRecord = oldRecordsMap.get(String.valueOf(updatedRecord.get('Id')));
                Object newFieldValue = getValueIfChanged(updatedRecord, oldRecord, trackedField); // better name for this variable
                if(newFieldValue != null) {
                    updateEvent.put(trackedField, newFieldValue);
                }
            }
            if(updateEvent != new TrailheadEntityUpdateEvent__e()) {
                updateEvents.add(updateEvent);
            }
        }

        EventBus.publish(updateEvents);
        // bulkified => need some loops, have to work through how many should be nested
        // create platform events with changed formula/picklist fields, changed values, and record ids/external ids
    }

    private static Object getValueIfChanged(sObject updatedRecord, sObject oldRecord, String fieldName) {
        if(updatedRecord.get(fieldName) != oldRecord.get(fieldName)) {
            return updatedRecord.get(fieldName);
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
}