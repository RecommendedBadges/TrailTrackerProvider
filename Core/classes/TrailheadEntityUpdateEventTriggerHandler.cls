/**
 * Trigger handler for the TrailheadEntityUpdateEvent__e platform event
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class TrailheadEntityUpdateEventTriggerHandler extends TriggerHandler {
    private static final List<String> systemPlatformEventFields {
        get {
            if(systemPlatformEventFields == null) {
                systemPlatformEventFields = new List<String>{'CreatedById', 'CreatedDate', 'EventUuid', 'ReplayId'};
            }
            return systemPlatformEventFields;
        }
        set;
    }

    /**
     * Constructor for trigger handler
     */
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
            Set<String> updatedFields = new Set<String>();
            
            for(String populatedField : populatedFieldsMap.keySet()) {
                if(systemPlatformEventFields.contains(populatedField) == false) {
                    teu.put(populatedField, populatedFieldsMap.get(populatedField));
                }
            }
            trailheadEntityUpdates.add(teu);
        }
        List<Database.SaveResult> saveResults = Database.insert(trailheadEntityUpdates, false);
        DMLUtils.logErrors(saveResults, 'TrailheadEntityUpdateEventTriggerHandler');
    }
}