/**
 * Batch Apex job to make callout to Recommended Badges org with details of changes to trailheadapp__Badge__c and trailheadapp__Trail__c records.
 * @author Ben Learn
 * @since 06-01-2023
 * @group Core
 */
public without sharing class BatchTrailheadEntityUpdateSync implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    private static final String BADGE_ENTITY_TYPE = 'trailheadapp__Badge__c';
    private static final String TRAIL_ENTITY_TYPE = 'trailheadapp__Trail__c';
    private static final Map<String, String> nameFieldByEntityType = new Map<String, String>{BADGE_ENTITY_TYPE => 'BadgeName__c', TRAIL_ENTITY_TYPE => 'TrailName__c'};
    private Integer numSuccessfulUpdates;

    @SuppressWarnings('PMD.ApexDoc')
    public BatchTrailheadEntityUpdateSync() {
        this.numSuccessfulUpdates = 0;
    }

    /**
     * Returns all TrailheadEntityUpdate__c records in org. 
     * @param bc BatchableContext for ongoing Apex batch job.
     * @return  `Database.QueryLocator`
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT APIName__c, Archived__c, Description__c, EntityType__c, Icon__c, Level__c, Name__c, Products__c, Type__c, UpdatedFields__c, URL__c FROM TrailheadEntityUpdate__c'
        );
    }

    /**
     * Makes callout to Recommended Badges org with details of changed trailheadapp__Badge__c and trailheadapp__Trail__c records. Hard deletes corresponding Trailhead Entity 
     * Update records if successful.
     * @param bc Batchable context for ongoing Apex batch job.
     * @param trailheadEntityUpdates Trailhead Entity Update records for current batch. 
     */    
    public void execute(Database.BatchableContext bc, List<TrailheadEntityUpdate__c> trailheadEntityUpdates) {
        Map<String, Map<String, Object>> updatedBadgesByAPIName = new Map<String, Map<String, Object>>();
        Map<String, Map<String, Object>> updatedTrailsByAPIName = new Map<String, Map<String, Object>>();
        
        Map<String, Object> updatedTrailheadEntity;
        for(TrailheadEntityUpdate__c teu : trailheadEntityUpdates) {
            updatedTrailheadEntity = new Map<String, Object>();
            for(String updatedField : teu.UpdatedFields__c.split(';')) {
                if(updatedField == 'Name__c') {
                    updatedTrailheadEntity.put(nameFieldByEntityType.get(teu.EntityType__c), teu.get(updatedField));
                } else {
                    updatedTrailheadEntity.put(updatedField, teu.get(updatedField));
                }
            }
            if(teu.EntityType__c == BADGE_ENTITY_TYPE) {
                updatedBadgesByAPIName.put(teu.APIName__c, updatedTrailheadEntity);
            } else if(teu.EntityType__c == TRAIL_ENTITY_TYPE) {
                updatedTrailsByAPIName.put(teu.APIName__c, updatedTrailheadEntity);
            }
        }

        if((updatedBadgesByAPIName.size() > 0) || (updatedTrailsByAPIName.size() > 0)) {
            try {
                HttpRequest request = new HttpRequest();
                request.setEndpoint('callout:RecommendedBadges/services/apexrest/TrailheadEntities/');
                request.setMethod('PATCH');
                request.setHeader('Content-Type', 'application/json');
                request.setBody('{"updatedBadgesByAPIName": ' + JSON.serialize(updatedBadgesByAPIName) + ', "updatedTrailsByAPIName": ' + JSON.serialize(updatedTrailsByAPIName) + '}');
                System.debug(request.getBody());
                HttpResponse response = new Http().send(request);
        
                if(response.getStatusCode() == 204) {
                    this.numSuccessfulUpdates += trailheadEntityUpdates.size();
                    Database.delete(trailheadEntityUpdates);
                    Database.emptyRecycleBin(trailheadEntityUpdates);
                } else {
                    Logger.error(new LogMessage('Error with callout to Recommended Badges. {0}. {1}', response.toString(), response.getBody()));
                    Logger.saveLog();
                }
            } catch(Exception e) {
                Logger.error(new LogMessage('Error with callout to Recommended Badges. {0}: {1}. \n{2}', e.getTypeName(), e.getMessage(), e.getStackTraceString()));
                Logger.saveLog();
            }
        }
    }

    /**
     * Logs number of successful Trailhead Entity updates.
     * @param bc Batchable context for ongoing Apex batch job.
     */    
    public void finish(Database.BatchableContext bc) {
        if(this.numSuccessfulUpdates > 0) {
            Logger.info(new LogMessage('Successfully updated {0} Trailhead Entities.', this.numSuccessfulUpdates));
            Logger.saveLog();
        }
    }
}