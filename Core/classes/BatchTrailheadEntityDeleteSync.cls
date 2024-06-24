/**
 * Batch Apex job to make callout to Recommended Badges org with API names of deleted trailheadapp__Badge__c and trailheadapp__Trail__c records.
 * @author Ben Learn
 * @since 06-21-2023
 * @group Core
 */
public without sharing class BatchTrailheadEntityDeleteSync implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    private static final String BADGE_ENTITY_TYPE = 'trailheadapp__Badge__c';
    private static final String TRAIL_ENTITY_TYPE = 'trailheadapp__Trail__c';
    private Integer numSuccessfulDeletes;

    @SuppressWarnings('PMD.ApexDoc')
    public BatchTrailheadEntityDeleteSync() {
        this.numSuccessfulDeletes = 0;
    }

    /**
     * Returns all TrailheadEntityDelete__c records in org. 
     * @param bc BatchableContext for ongoing Apex batch job.
     * @return  `Database.QueryLocator`
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT APIName__c, EntityType__c FROM TrailheadEntityDelete__c');
    }

    /**
     * Makes callout to Recommended Badges org with API Names of archived trailheadapp__Badge__c and trailheadapp__Trail__c records. Hard deletes corresponding Trailhead Entity 
     * Delete records if successful.
     * @param bc Batchable context for ongoing Apex batch job.
     * @param trailheadEntityDeletes Trailhead Entity Delete records for current batch. 
     */    
    public void execute(Database.BatchableContext bc, List<TrailheadEntityDelete__c> trailheadEntityDeletes) {
        List<String> deletedBadgeAPINames = new List<String>();
        List<String> deletedTrailAPINames = new List<String>();

        for(TrailheadEntityDelete__c ted : trailheadEntityDeletes) {
            if(ted.EntityType__c == BADGE_ENTITY_TYPE) {
                deletedBadgeAPINames.add(ted.APIName__c);
            } else if(ted.EntityType__c == TRAIL_ENTITY_TYPE) {
                deletedTrailAPINames.add(ted.APIName__c);
            }
        }

        if((deletedBadgeAPINames.size() > 0) || (deletedTrailAPINames.size() > 0)) {
            try {
                HttpRequest request = new HttpRequest();
                request.setEndpoint('callout:RecommendedBadges/services/apexrest/TrailheadEntities/');
                request.setMethod('DELETE');
                request.setHeader('Content-Type', 'application/json');
                request.setBody('{"deletedBadgeAPINames": ' + JSON.serialize(deletedBadgeAPINames) + ', "deletedTrailAPINames": ' + JSON.serialize(deletedTrailAPINames) + '}');
                HttpResponse response = new Http().send(request);

                if(response.getStatusCode() == 200) {
                    this.numSuccessfulDeletes += trailheadEntityDeletes.size();
                    Database.delete(trailheadEntityDeletes);
                    Database.emptyRecycleBin(trailheadEntityDeletes);
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
     * Logs number of successful Trailhead Entity deletes.
     * @param bc Batchable context for ongoing Apex batch job.
     */    
    public void finish(Database.BatchableContext bc) {
        if(this.numSuccessfulDeletes > 0) {
            Logger.info(new LogMessage('Successfully deleted {0} Trailhead Entities.', this.numSuccessfulDeletes));
            Logger.saveLog();
        }
    }
}