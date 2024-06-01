public without sharing class BatchTrailheadEntityUpdateSync implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT APIName__c, Archived__c, Description__c, Icon__c, Level__c, Name__c, Products__c, Type__c, URL__c FROM TrailheadEntityUpdate__c');
    }

    public void execute(Database.BatchableContext bc, List<TrailheadEntityUpdate__c> trailheadEntityUpdates) {
        for(TrailheadEntityUpdate__c teu : trailheadEntityUpdates) {
            
        }
    }

    public void finish(Database.BatchableContext bc) {

    }
}