trigger StorageEventTrigger on StorageEvent__e (after insert) {
    new StorageEventTriggerHandler().execute();
}