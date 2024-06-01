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
                new ControlledValueField(
                    TrailheadEntityUpdateEvent__e.EntityType__c, 
                    PicklistValueManager.getFieldValues(TrailheadEntityUpdate__c.sObjectType, TrailheadEntityUpdate__c.EntityType__c)
                ),
                new TestSupport.TestDataField(TrailheadEntityUpdateEvent__e.Products__c, 'New products.'),
                new TestSupport.TestDataField(TrailheadEntityUpdateEvent__e.UpdatedFields__c, 'Products__c')
            }
        );
        teueGenerator.generate();
        List<sObject> testEvents = teueGenerator
            .setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdateEvent__e.Icon__c, 'www.testicon.com'))
            .setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdateEvent__e.UpdatedFields__c, 'Icon__c;Products__c'))
            .generate();
        
        Test.startTest();
        EventBus.publish(testEvents);
        Test.stopTest();

        List<TrailheadEntityUpdate__c> productUpdates = [
            SELECT Id 
            FROM TrailheadEntityUpdate__c 
            WHERE Products__c = 'New products.' AND Icon__c = null AND UpdatedFields__c='Products__c'
        ];
        List<TrailheadEntityUpdate__c> productAndIconUpdates = [
            SELECT Id 
            FROM TrailheadEntityUpdate__c 
            WHERE Products__c = 'New products.' AND Icon__c = 'www.testicon.com' AND UpdatedFields__c='Icon__c;Products__c'
        ];
        Assert.areEqual(200, productUpdates.size(), 'Expected 200 records for entities updates to the Products field only.');
        Assert.areEqual(200, productAndIconUpdates.size(), 'Expected 200 records for entities updates to the Products and Icon fields.');
    }
}