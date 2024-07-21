@isTest
private class StorageEventTriggerHandler_Tests {
    @isTest
    private static void it_should_hard_delete_records_based_off_storage_events() {
        StorageEventTS storageEventGenerator = new StorageEventTS(
            new Map<String, Object>{
                'generatorReturnValue' => 'all',
                'numberToGenerate' => 1
            }, 
            new List<TestSupport.TestDataField>{
                new TestSupport.TestDataField(StorageEvent__e.ConditionField__c, 'trailheadapp__Archived__c'),
                new TestSupport.TestDataField(StorageEvent__e.ConditionOperator__c, '='),
                new TestSupport.TestDataField(StorageEvent__e.ConditionValue__c, 'true'),
                new TestSupport.TestDataField(StorageEvent__e.Object__c, 'trailheadapp__Badge__c')
            }
        );
        storageEventGenerator.generate();
        storageEventGenerator.setFieldSpec(new TestSupport.TestDataField(StorageEvent__e.Object__c, 'trailheadapp__Trail__c'))
            .generate();
        List<sObject> storageEvents = storageEventGenerator.overwriteFieldSpecs(new List<TestSupport.TestDataField>{
            new TestSupport.TestDataField(StorageEvent__e.Object__c, 'trailheadapp__Trailmix__c')
        }).generate();

        BadgeTS badgeGenerator = new BadgeTS(
            new Map<String, Object>{'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new BooleanField(trailheadapp__Badge__c.trailheadapp__Archived__c)}
        );
        insert badgeGenerator.generate();

        TrailTS trailGenerator = new TrailTS(
            new Map<String, Object>{'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new BooleanField(trailheadapp__Trail__c.trailheadapp__Archived__c)}
        );
        insert trailGenerator.generate();

        TrailmixTS trailmixGenerator = new TrailmixTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert trailmixGenerator.generate();

        Test.startTest();
        EventBus.publish((List<StorageEvent__e>) storageEvents);
        Test.stopTest();

        Assert.areEqual(100, [SELECT COUNT() FROM trailheadapp__Badge__c], 'Expected archived Badges to be hard deleted.');
        Assert.areEqual(100, [SELECT COUNT() FROM trailheadapp__Trail__c], 'Expected archived Trails to be hard deleted.');
        Assert.areEqual(0, [SELECT COUNT() FROM trailheadapp__Trailmix__c], 'Expected all Trailmixes to be hard deleted.');
    }

    @isTest
    private static void it_should_throw_exceptions_on_invalid_conditions() {
        StorageEventTriggerHandler.StorageEventException notAllPopulatedException;
        StorageEventTriggerHandler.StorageEventException unsupportedOperatorException;
        String unsupportedOperator = 'IN';

        Test.startTest();
        try {
            StorageEventTriggerHandler.validateCondition('a', 'b', null);
            Assert.fail();
        } catch(StorageEventTriggerHandler.StorageEventException e) {
            notAllPopulatedException = e;
        }

        try {
            StorageEventTriggerHandler.validateCondition('a', unsupportedOperator, 'b');
            Assert.fail();
        } catch(StorageEventTriggerHandler.StorageEventException e) {
            unsupportedOperatorException = e;
        }
        Test.stopTest();

        Assert.areEqual(
            StorageEventTriggerHandler.NOT_ALL_POPULATED_ERROR_MESSAGE, 
            notAllPopulatedException.getMessage(), 
            'Expected exception when not all condition fields are populated.'
        );
        Assert.areEqual(
            StorageEventTriggerHandler.UNSUPPORTED_OPERATOR_ERROR_MESSAGE,
            unsupportedOperatorException.getMessage(),
            'Expected exception when unsupported operator is provided.'
        );
    }
    
    @isTest
    private static void it_should_sanitize_valid_conditions() {
        Test.startTest();
        String validatedCondition = StorageEventTriggerHandler.validateCondition('a', '=', 'b');
        Test.stopTest();

        Assert.areEqual('a = b', validatedCondition, 'Expected condition to be validated and sanitized.');
    }

    @isTest
    private static void it_should_return_a_null_value_when_no_condition() {
        Test.startTest();
        String validatedCondition = StorageEventTriggerHandler.validateCondition(null, null, null);
        Test.stopTest();
        Assert.isNull(validatedCondition, 'Expected null return value from StorageEventTriggerHandler.validateCondition() when no condition is provided.');
    }
}