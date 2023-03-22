trigger TrailTrigger on trailheadapp__Trail__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new TrailTriggerHandler().execute();
}