/**
 * Domain class for functionality shared between the trailheadapp__Badge__c and trailheadapp__Trail__c custom objects
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
**/
public inherited sharing class TrailheadEntities {
    private Map<Id, sObject> updatedRecordsMap;
    private Map<Id, sObject> oldRecordsMap;
    private String entityType;
    private String namespacePrefix;
    private static final String ARCHIVED_FIELD = 'trailheadapp__Archived__c';
    
    @TestVisible
    private static Map<String, List<String>> trackedFieldsByObject {
        get {
            if(trackedFieldsByObject == null) {
                List<TrackedField__mdt> trackedFields = [
                    SELECT DeveloperName, Field__r.NamespacePrefix, Field__r.QualifiedApiName, Object__r.QualifiedApiName
                    FROM TrackedField__mdt
                ];
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

    @SuppressWarnings('PMD.ApexDoc')
    public TrailheadEntities(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap, String entityType) {
        this.updatedRecordsMap = updatedRecordsMap;
        this.oldRecordsMap = oldRecordsMap;
        this.entityType = entityType;

        // if there is more than one occurrence of __ in the object API name, then the entity must be a custom object with a namespace prefix, so populate this.namespacePrefix
        if(this.entityType.countMatches('__') > 1) {
            this.namespacePrefix = this.entityType.substring(0, this.entityType.indexOf('__') + 2);
        }
    }

    /**
     * Creates TrailheadEntityUpdateEvent__e platform events for changes to tracked fields on Badges and Trails
     * @return  `List<TrailheadEntityUpdateEvent__e>`
     */    
    public List<TrailheadEntityUpdateEvent__e> generateUpdateEvents() {
        List<TrailheadEntityUpdateEvent__e> updateEvents = new List<TrailheadEntityUpdateEvent__e>();
        for(sObject updatedRecord : updatedRecordsMap.values()) {
            sObject oldRecord = oldRecordsMap.get(String.valueOf(updatedRecord.get('Id')));

            System.debug(updatedRecord.get(ARCHIVED_FIELD));
            System.debug(oldRecord.get(ARCHIVED_FIELD));
            // skip current iteration if old and new record both have Archived set to true
            if((updatedRecord.get(ARCHIVED_FIELD) == true) && (oldRecord.get(ARCHIVED_FIELD) == true)) {
                continue;
            }

            TrailheadEntityUpdateEvent__e updateEvent = new TrailheadEntityUpdateEvent__e();
            Set<String> updatedFields = new Set<String>();
            for(String trackedField : trackedFieldsByObject.get(this.entityType)) {
                String updateEventFieldName = trackedField.removeStart(this.namespacePrefix);
                // if the field is a standard field, it doesn't have the __c suffix, but the corresponding platform event field is a custom field, so it will have the __c suffix
                if(trackedField.indexOf('__c') == -1) {
                    updateEventFieldName += '__c';
                }
                populateFieldIfTrackedAndChanged(updatedRecord, oldRecord, trackedField, updateEventFieldName, updateEvent, updatedFields);
            }

            if(updateEvent.getPopulatedFieldsAsMap().isEmpty() == false) {
                updateEvent.APIName__c = String.valueOf(updatedRecord.get('trailheadapp__API_Name__c'));
                updateEvent.EntityType__c = this.entityType;
                updateEvent.UpdatedFields__c = String.join(new List<String>(updatedFields), ';');
                updateEvents.add(updateEvent);
            }
        }
        return updateEvents;
    }

    private static void populateFieldIfTrackedAndChanged(sObject updatedRecord, sObject oldRecord, String fieldName, String updateEventFieldName, TrailheadEntityUpdateEvent__e updateEvent, Set<String> updatedFields) { 
        if(updatedRecord.get(fieldName) != oldRecord.get(fieldName)) {
            updateEvent.put(updateEventFieldName, String.valueOf(updatedRecord.get(fieldName)));
            updatedFields.add(updateEventFieldName);
        }
    }
}