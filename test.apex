/*List<TrackedField__mdt> trackedFields = [SELECT MasterLabel, DeveloperName, Field__r.QualifiedApiName, Object__r.QualifiedApiName FROM TrackedField__mdt];
for(TrackedField__mdt tf : trackedFields) {
    System.debug(tf.Field__r.QualifiedApiName);
}*/
new TrailheadEntities(new Map<Id, trailheadapp__Badge__c>(), new Map<Id, trailheadapp__Badge__c>()).publishUpdateEvents();