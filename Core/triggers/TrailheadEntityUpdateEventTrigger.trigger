trigger TrailheadEntityUpdateEventTrigger on TrailheadEntityUpdateEvent__e (after insert) {
    new TrailheadEntityUpdateEventTriggerHandler().execute();
}