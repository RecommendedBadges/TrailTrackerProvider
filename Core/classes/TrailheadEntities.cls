/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 06-01-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class TrailheadEntities {
    private static Map<String, TrackedField> trackedFields {
        get {
            if(trackedFields == null) {
                List<TrailheadEntityTrackedField__mdt> trailheadEntityTrackedFields = [
                    SELECT BadgeField__c, TrailField__c, Suffix__c, MasterLabel
                     FROM TrailheadEntityTrackedField__mdt
                ];
                trackedFields = new Map<String, TrackedField>();
                String fieldApiName;
                for(TrailheadEntityTrackedField__mdt tetf : trailheadEntityTrackedFields) {
                    fieldApiName = tetf.Suffix__c == null ? tetf.MasterLabel : tetf.MasterLabel + tetf.Suffix__c;
                    trackedFields.put(fieldApiName, new TrackedField(fieldApiName, tetf.BadgeField__c, tetf.TrailField__c));
                }
            }
            return trackedFields;
        } set {
            trackedFields = value;
        }
    }

    private Map<Id, sObject> updatedRecordsMap;
    private Map<Id, sObject> oldRecordsMap;
    private String entityType;

    public TrailheadEntities(Map<Id, trailheadapp__Badge__c> updatedBadgesMap, Map<Id, trailheadapp__Badge__c> oldBadgesMap) {
        this.updatedRecordsMap = (Map<Id, sObject>) updatedBadgesMap;
        this.oldRecordsMap = (Map<Id, sObject>) oldBadgesMap;
        this.entityType = 'trailheadapp__Badge__c';
    }

    public TrailheadEntities(Map<Id, trailheadapp__Trail__c> updatedTrailsMap, Map<Id, trailheadapp__Trail__c> oldTrailsMap) {
        this.updatedRecordsMap = (Map<Id, sObject>) updatedTrailsMap;
        this.oldRecordsMap = (Map<Id, sObject>) oldTrailsMap;
        this.entityType = 'trailheadapp__Trail__c';
    }

    public void publishUpdateEvents() {
        String namespacePrefix = 'trailheadapp__'; // todo - make more dynamic

        
        List<TrailheadEntityUpdateEvent__e> updateEvents = new List<TrailheadEntityUpdateEvent__e>();
        for(sObject updatedRecord : updatedRecordsMap.values()) {
            TrailheadEntityUpdateEvent__e updateEvent = new TrailheadEntityUpdateEvent__e();
            for(String trackedField : trackedFields.keySet()) {
                //if(trackedFields.get(trackedField).badgeField && this.entityType)
                // updating here
                sObject oldRecord = oldRecordsMap.get(String.valueOf(updatedRecord.get('Id')));
                /*Object newFieldValue = getNewFieldValue(updatedRecord, oldRecord, customUpdateEventField, namespacePrefix); // better name for this variable
                if(newFieldValue != null) {
                    updateEvent.put(customUpdateEventField, newFieldValue);
                }*/
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
        // everything's good here for this method. just want to update the access modifier/generalize/abstract
        // is there a difference between badge and trail fields? i think so - how is that difference handled? (difference is that badge has type and trail doesn't)
        // update getNewFieldValue for archived field - only care about archived switching from false to true
        // gotta handle name fields appropriately
    }

    private class TrackedField {
        private Boolean badgeField;
        private Boolean trailField;
        private String fieldName;
        //List<String> 

        private TrackedField(String fieldName, Boolean badgeField, Boolean trailField) {
            this.fieldName = fieldName;
            this.badgeField = badgeField;
            this.trailField = trailField;
        }
    }
}