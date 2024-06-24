@isTest(isParallel=true)
private class TrailheadEntityEventTriggerHandler_Tests {
    @isTest
    private static void it_should_insert_trailhead_entity_updates() {
        TrailheadEntityEventTS eventGenerator = new TrailheadEntityEventTS(
            new Map<String, Object>{'generatorReturnValue' => 'all'},
            new List<TestSupport.TestDataField>{
                new TestSupport.TestDataField(TrailheadEntityEvent__e.Operation__c, 'update'),
                new TestSupport.TestDataField(TrailheadEntityEvent__e.Products__c, 'New products.')
            }
        );
        eventGenerator.generate();
        List<sObject> testEvents = eventGenerator
            .setFieldSpec(new TestSupport.TestDataField(TrailheadEntityEvent__e.Icon__c, 'www.testicon.com'))
            .generate();
        
        Test.startTest();
        EventBus.publish(testEvents);
        Test.stopTest();

        List<TrailheadEntityUpdate__c> productUpdates = [
            SELECT Id
            FROM TrailheadEntityUpdate__c
            WHERE Products__c = 'New products.' AND Icon__c = null AND UpdatedFields__c = 'Products__c'
        ];
        List<TrailheadEntityUpdate__c> productAndIconUpdates = [
            SELECT Id 
            FROM TrailheadEntityUpdate__c 
            WHERE Products__c = 'New products.' AND Icon__c = 'www.testicon.com' AND UpdatedFields__c='Icon__c;Products__c'
        ];
        Assert.areEqual(200, productUpdates.size(), 'Expected 200 records for entities updates to the Products field only.');
        Assert.areEqual(200, productAndIconUpdates.size(), 'Expected 200 records for entities updates to the Products and Icon fields.');
    }

    @isTest
    private static void it_should_insert_trailhead_entity_deletes() {
        TrailheadEntityEventTS eventGenerator = new TrailheadEntityEventTS(
            new Map<String, Object>{'generatorReturnValue' => 'all'},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(TrailheadEntityEvent__e.Operation__c, 'delete')}
        );
        List<sObject> testEvents = eventGenerator.generate();
    
        Test.startTest();
        EventBus.publish(testEvents);
        Test.stopTest();

        Set<String> eventAPINames = eventGenerator.eventsByAPIName.keySet();
        List<TrailheadEntityDelete__c> deletes = [
            SELECT Id, APIName__c, EntityType__c
            FROM TrailheadEntityDelete__c
            WHERE APIName__c IN :eventAPINames
        ];
        Assert.areEqual(200, deletes.size(), 'Expected one Trailhead Entity Delete record for each Trailhead Entity Event.');
        for(TrailheadEntityDelete__c d : deletes) {
            Assert.areEqual(
                d.EntityType__c, 
                eventGenerator.eventsByAPIName.get(d.APIName__c).get('EntityType__c'), 
                'Expected entity type of Trailhead Delete to match entity type of Traihlead Event.'
            );
        }
    }
}