/**
 * Trigger handler for the TrailheadEntityUpdateEvent__e platform event
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class TrailheadEntityUpdateEventTriggerHandler extends TriggerHandler {
    public TrailheadEntityUpdateEventTriggerHandler() {
        super();
    }

    /**
     * 
     * @param newRecordsMap Map of IDs to newly inserted TrailheadEntityUpdateEvent__e events
     */
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        List<sObject> trailheadEntityUpdates = new List<sObject>();
        for(sObject teuEvent : newRecordsMap.values()) {
            Map<String, Object> populatedFieldsMap = teuEvent.getPopulatedFieldsAsMap();
            sObject teu = new TrailheadEntityUpdate__c();
            
            for(String populatedField : populatedFieldsMap.keySet()) {
                teu.put(populatedField, populatedFieldsMap.get(populatedField));
            }
            trailheadEntityUpdates.add(teu);
        }
        Database.insert(trailheadEntityUpdates);
    }
}