@isTest(isParallel=true)
private class TrailheadEntityUpdateEvtTgrHdlr_Tests {
    @isTest
    private static void it_should_insert_trailhead_entity_updates() {
        TrailheadEntityUpdateEventTS teueGenerator = new TrailheadEntityUpdateEventTS(new Map<String, Object>{
            'numberToGenerate' => 1
        });
        /*TrailheadEntityUpdateEvent__e teuEvent = new TrailheadEntityUpdateEvent__e();
        teuEvent.ExternalId__c = 'test';
        teuEvent.Archived__c = false;
        EventBus.publish(teuEvent);
        Test.getEventBus().deliver();*/
    }
}