/**
 * Trigger handler for the TrailheadEntityEvent__e platform event
 * @author Ben Learn
 * @since 06-02-2023
 * @group Core
 */
public without sharing class TrailheadEntityEventTriggerHandler extends TriggerHandler {
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
    public TrailheadEntityEventTriggerHandler() {
        super();
    }


    /**
     * 
     * @param newRecordsMap Map of IDs to newly inserted TrailheadEntityEvent__e events
     */
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        List<TrailheadEntityEvent__e> events = (List<TrailheadEntityEvent__e>) newRecordsMap.values();
        List<TrailheadEntityUpdate__c> trailheadEntityUpdates = new List<TrailheadEntityUpdate__c>();
        List<TrailheadEntityDelete__c> trailheadEntityDeletes = new List<TrailheadEntityDelete__c>();

        for(TrailheadEntityEvent__e ev : events) {
            if(ev.Operation__c == 'delete') {
                TrailheadEntityDelete__c ted = new TrailheadEntityDelete__c(
                    APIName__c = ev.APIName__c, EntityType__c = ev.EntityType__c
                );
                trailheadEntityDeletes.add(ted);
            } else if(ev.Operation__c == 'update') {
                Map<String, Object> populatedFieldsMap = ev.getPopulatedFieldsAsMap();
                TrailheadEntityUpdate__c teu = new TrailheadEntityUpdate__c();
                Set<String> updatedFields = new Set<String>();
                
                for(String populatedField : populatedFieldsMap.keySet()) {
                    if(systemPlatformEventFields.contains(populatedField) == false && populatedField != 'Operation__c') { // temp operation ignored
                        teu.put(populatedField, populatedFieldsMap.get(populatedField));
                    }
                }
                trailheadEntityUpdates.add(teu);
            }
        }

        List<Database.SaveResult> saveResults;
        if(trailheadEntityUpdates.size() > 0) {
            saveResults = Database.insert(trailheadEntityUpdates, false);
            DMLUtils.logErrors(saveResults, 'TrailheadEntityEventTriggerHandler');
        }
        if(trailheadEntityDeletes.size() > 0) {
            saveResults = Database.insert(trailheadEntityDeletes, false);
            DMLUtils.logErrors(saveResults, 'TrailheadEntityEventTriggerHandler');
        }
    }
}