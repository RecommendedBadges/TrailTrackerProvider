trigger BadgeTrigger on trailheadapp__Badge__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new BadgeTriggerHandler().execute();
}