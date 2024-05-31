@isTest(isParallel=true)
private class TrailheadEntityUpdateEvtTgrHdlr_Tests {
    @isTest
    private static void it_should_insert_trailhead_entity_updates() {
        TrailheadEntityUpdateEventTS teueGenerator = new TrailheadEntityUpdateEventTS(
            new Map<String, Object>{
                'generateRecordIDS' => false,
                'numberToGenerate' => 200,
                'generatorReturnValue' => 'all'
            },
            new List<TestSupport.TestDataField>{
                new TestSupport.TestDataField(TrailheadEntityUpdateEvent__e.Products__c, 'New products.')
            }
        );
        teueGenerator.generate();
        List<sObject> testEvents = teueGenerator.setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdateEvent__e.Icon__c, 'www.newicon.com')).generate();
        
        Test.startTest();
        EventBus.publish(testEvents);
        Test.stopTest();

        List<TrailheadEntityUpdate__c> productUpdates = [SELECT Id FROM TrailheadEntityUpdate__c WHERE Products__c = 'New products.' AND Icon__c = null];
        List<TrailheadEntityUpdate__c> productAndIconUpdates = [SELECT Id FROM TrailheadEntityUpdate__c WHERE Products__c = 'New products.' AND Icon__c = null];

        Assert.areEqual(200, productUpdates.size(), 'Expected 200 records for entities updates to the Products field only.');
        Assert.areEqual(200, productAndIconUpdates.size(), 'Expected 200 records for entities updates to the Products and Icon fields.');
    }
}