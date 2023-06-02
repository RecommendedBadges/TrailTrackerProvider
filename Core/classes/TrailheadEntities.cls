/**
 * Domain class for functionality shared between the trailheadapp__Badge__c and trailheadapp__Trail__c custom objects
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
**/
public inherited sharing class TrailheadEntities {
    private static Map<String, List<TrackedField__mdt>> trackedFieldsByObject {
        get {
            if(trackedFieldsByObject == null) {
                List<TrackedField__mdt> trackedFields = [
                    SELECT DeveloperName, Field__r.NamespacePrefix, Field__r.QualifiedApiName, Object__r.QualifiedApiName
                    FROM TrackedField__mdt
                ];
                trackedFieldsByObject = new Map<String, List<TrackedField__mdt>>();
                for(TrackedField__mdt tf : trackedFields) {
                    if(trackedFieldsByObject.get(tf.Object__r.QualifiedApiName) == null) {
                        trackedFieldsByObject.put(tf.Object__r.QualifiedApiName, new List<TrackedField__mdt>{tf});
                    } else {
                        List<TrackedField__mdt> tempTrackedFields = trackedFieldsByObject.get(tf.Object__r.QualifiedApiName);
                        tempTrackedFields.add(tf);
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
    private String namespacePrefix;

    public TrailheadEntities(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap, String entityType) {
        this.updatedRecordsMap = updatedRecordsMap;
        this.oldRecordsMap = oldRecordsMap;
        this.entityType = entityType;

        // if there is more than one occurrence of __ in the object API name, then the entity must be a custom object with a namespace prefix, so populate this.namespacePrefix
        if(this.entityType.countMatches('__') > 1) {
            this.namespacePrefix = this.entityType.substring(0, this.entityType.indexOf('__'));
        }
    }

    public void publishUpdateEvents() {
        List<TrailheadEntityUpdateEvent__e> updateEvents = new List<TrailheadEntityUpdateEvent__e>();
        for(sObject updatedRecord : updatedRecordsMap.values()) {
            TrailheadEntityUpdateEvent__e updateEvent = new TrailheadEntityUpdateEvent__e();
            for(TrackedField__mdt trackedField : trackedFieldsByObject.get(this.entityType)) {
                sObject oldRecord = oldRecordsMap.get(String.valueOf(updatedRecord.get('Id')));
                Object newFieldValue = getValueIfChanged(updatedRecord, oldRecord, trackedField.Field__r.QualifiedApiName);
                String updateEventFieldName = trackedField.Field__r.QualifiedApiName.removeStart(this.namespacePrefix);
                
                // if the field is a standard field, it doesn't have the __c suffix, but the correspond platform event field is a custom field, so it will have the __c suffix
                if(trackedField.Field__r.QualifiedApiName.indexOf('__c') == -1) {
                    updateEventFieldName += '__c';
                }
                if(newFieldValue != null) {
                    updateEvent.put(updateEventFieldName, newFieldValue);
                }
            }
            if(updateEvent != new TrailheadEntityUpdateEvent__e()) {
                updateEvent.ExternalId__c = String.valueOf(updatedRecord.get('trailheadapp__External_Id__c'));
                updateEvents.add(updateEvent);
            }
        }
        EventBus.publish(updateEvents);
    }

    private static Object getValueIfChanged(sObject updatedRecord, sObject oldRecord, String fieldName) {
        if(updatedRecord.get(fieldName) != oldRecord.get(fieldName)) {
            return updatedRecord.get(fieldName);
        }
        return null;
    }
}