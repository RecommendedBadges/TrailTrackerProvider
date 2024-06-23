trigger TrailheadEntityEventTrigger on TrailheadEntityEvent__e (after insert) {
    new TrailheadEntityEventTriggerHandler().execute();
}