@isTest
private class BatchTrailheadEntityUpdateSync_Tests {
    @isTest
    private static void it_should_not_make_callout_without_existing_updates() {
        Test.startTest();
        Database.executeBatch(new BatchTrailheadEntityUpdateSync());
        Test.stopTest();

        Assert.areEqual(0, Limits.getCallouts(), 'Did not expect callout to be made when there are no TrailheadEntityUpdate__c records.');
        Assert.areEqual(0, Limits.getDmlStatements(), 'Did not expect DML statements from BatchTrailheadEntityUpdateSync when there are no TrailheadEntityUpdate__c records.');
    }

    @isTest
    private static void it_should_delete_records_after_successful_callout() {
        TrailheadEntityUpdateTS trailheadEntityUpdateGenerator = new TrailheadEntityUpdateTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 40, 'generatorReturnValue' => 'all'},
            new List<TestSupport.TestDataField>{
                new CounterSuffixField(TrailheadEntityUpdate__c.Name__c, 'Test Trail '),
                new TestSupport.TestDataField(TrailheadEntityUpdate__c.Description__c, 'Updated description.'),
                new TestSupport.TestDataField(TrailheadEntityUpdate__c.EntityType__c, 'trailheadapp__Trail__c')
            }
        );
        trailheadEntityUpdateGenerator.generate();
        trailheadEntityUpdateGenerator.setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdate__c.Icon__c, 'www.updatedicon.com')).generate();
        trailheadEntityUpdateGenerator.setFieldSpec(new RandomPicklistValueField(TrailheadEntityUpdate__c.Level__c)).generate();
        trailheadEntityUpdateGenerator.overwriteFieldSpecs(new List<TestSupport.TestDataField>{
            new CounterSuffixField(TrailheadEntityUpdate__c.Name__c, 'Test Badge '),
            new TestSupport.TestDataField(TrailheadEntityUpdate__c.EntityType__c, 'trailheadapp__Badge__c'),
            new RandomPicklistValueField(TrailheadEntityUpdate__c.Type__c)
        }).generate();
        trailheadEntityUpdateGenerator.setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdate__c.Products__c, 'Updated products.')).generate();

        insert trailheadEntityUpdateGenerator.setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdate__c.URL__c, 'www.updatedurl.com')).generate();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock('', 204));
        Database.executeBatch(new BatchTrailheadEntityUpdateSync(), trailheadEntityUpdateGenerator.records.size());
        Test.stopTest();
        
        List<LogEntry__c> logEntries = [
            SELECT Id, Message__c 
            FROM LogEntry__c 
            WHERE 
                OriginSourceActionName__c = 'finish' 
                AND OriginSourceAPIName__c = 'BatchTrailheadEntityUpdateSync' 
                AND OriginSourceMetadataType__c = 'ApexClass' 
                AND LoggingLevel__c = 'INFO'
        ];

        Assert.areEqual(
            0, 
            [SELECT COUNT() FROM TrailheadEntityUpdate__c],
            'Expected all TrailheadEntityUpdate__c records to be deleted by BatchTrailheadEntityUpdateSync after successful callout.'
        );
        Assert.areEqual(1, logEntries.size(), 'Expected info debug log from BatchTrailheadEntityUpdateSync.finish().');
        Assert.areEqual(
            String.format('Successfully updated {0} Trailhead Entities.', new List<Object>{trailheadEntityUpdateGenerator.records.size()}),
            logEntries[0].Message__c,
            'Expected info debug log from BatchTrailheadEntityUpdateSync.finish().'
        );
    }

    @isTest
    private static void it_should_log_callout_errors() {
        String testResponseBody = '{"error": "Test internal error."}';
        String testStatus = 'Internal Server Error';
        Integer testStatusCode = 500;

        TrailheadEntityUpdateTS trailheadEntityUpdateGenerator = new TrailheadEntityUpdateTS(
            new Map<String, Object>{'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{
                new CounterSuffixField(TrailheadEntityUpdate__c.Name__c, 'Test Trail '),
                new TestSupport.TestDataField(TrailheadEntityUpdate__c.Description__c, 'Updated description.')
            }
        );
        insert trailheadEntityUpdateGenerator.generate();

        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(testResponseBody, testStatusCode, testStatus));

        Test.startTest();
        Database.executeBatch(new BatchTrailheadEntityUpdateSync(), trailheadEntityUpdateGenerator.records.size());
        Test.stopTest();

        List<LogEntry__c> logEntries = [
            SELECT Id, Message__c 
            FROM LogEntry__c 
            WHERE 
                OriginSourceActionName__c = 'execute' 
                AND OriginSourceAPIName__c = 'BatchTrailheadEntityUpdateSync' 
                AND OriginSourceMetadataType__c = 'ApexClass' 
                AND LoggingLevel__c = 'ERROR'
        ];  
        Assert.areEqual(1, logEntries.size(), 'Expected error debug log from BatchTrailheadEntityUpdateSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.startsWith('Error with callout to Recommended Badges.'), 'Expected error debug log from BatchTrailheadEntityUpdateSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.contains(testResponseBody), 'Expected error debug log from BatchTrailheadEntityUpdateSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.contains(testStatus), 'Expected error debug log from BatchTrailheadEntityUpdateSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.contains(String.valueOf(testStatusCode)), 'Expected error debug log from BatchTrailheadEntityUpdateSync.execute().');
    }
}