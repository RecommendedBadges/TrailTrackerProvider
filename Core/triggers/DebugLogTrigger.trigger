trigger DebugLogTrigger on trailheadapp__Debug_Log__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new DebugLogTriggerHandler().execute();
}