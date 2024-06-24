@isTest
private class BatchTrailheadEntityDeleteSync_Tests {
    @isTest
    private static void it_should_not_make_callout_without_existing_deletes() {
        Test.startTest();
        Database.executeBatch(new BatchTrailheadEntityDeleteSync());
        Test.stopTest();

        Assert.areEqual(0, Limits.getCallouts(), 'Did not expect callout to be made when there are no TrailheadEntityDelete__c records.');
        Assert.areEqual(0, Limits.getDmlStatements(), 'Did not expect DML statements from BatchTrailheadEntityDeleteSync when there are no TrailheadEntityDelete__c records.');
    }

    @isTest
    private static void it_should_delete_records_after_successful_callout() {
        TrailheadEntityDeleteTS trailheadEntityDeleteGenerator = new TrailheadEntityDeleteTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert trailheadEntityDeleteGenerator.generate();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock('', 200));
        Database.executeBatch(new BatchTrailheadEntityDeleteSync(), trailheadEntityDeleteGenerator.records.size());
        Test.stopTest();
        
        List<LogEntry__c> logEntries = [
            SELECT Id, Message__c 
            FROM LogEntry__c 
            WHERE 
                OriginSourceActionName__c = 'finish' 
                AND OriginSourceAPIName__c = 'BatchTrailheadEntityDeleteSync' 
                AND OriginSourceMetadataType__c = 'ApexClass' 
                AND LoggingLevel__c = 'INFO'
        ];

        Assert.areEqual(
            0, 
            [SELECT COUNT() FROM TrailheadEntityDelete__c],
            'Expected all TrailheadEntityDelete records to be deleted by BatchTrailheadEntityDeleteSync after successful callout.'
        );
        Assert.areEqual(1, logEntries.size(), 'Expected info debug log from BatchTrailheadEntityDeleteSync.finish().');
        Assert.areEqual(
            String.format('Successfully deleted {0} Trailhead Entities.', new List<Object>{trailheadEntityDeleteGenerator.records.size()}),
            logEntries[0].Message__c,
            'Expected info debug log from BatchTrailheadEntityDeleteSync.finish().'
        );
    }

    @isTest
    private static void it_should_log_callout_errors() {
        String testResponseBody = '{"error": "Test internal error."}';
        String testStatus = 'Internal Server Error';
        Integer testStatusCode = 500;

        TrailheadEntityDeleteTS trailheadEntityDeleteGenerator = new TrailheadEntityDeleteTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert trailheadEntityDeleteGenerator.generate();

        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(testResponseBody, testStatusCode, testStatus));

        Test.startTest();
        Database.executeBatch(new BatchTrailheadEntityDeleteSync(), trailheadEntityDeleteGenerator.records.size());
        Test.stopTest();

        List<LogEntry__c> logEntries = [
            SELECT Id, Message__c 
            FROM LogEntry__c 
            WHERE 
                OriginSourceActionName__c = 'execute' 
                AND OriginSourceAPIName__c = 'BatchTrailheadEntityDeleteSync' 
                AND OriginSourceMetadataType__c = 'ApexClass' 
                AND LoggingLevel__c = 'ERROR'
        ];  
        Assert.areEqual(1, logEntries.size(), 'Expected error debug log from BatchTrailheadEntityDeleteSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.startsWith('Error with callout to Recommended Badges.'), 'Expected error debug log from BatchTrailheadEntityDeleteSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.contains(testResponseBody), 'Expected error debug log from BatchTrailheadEntityDeleteSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.contains(testStatus), 'Expected error debug log from BatchTrailheadEntityDeleteSync.execute().');
        Assert.isTrue(logEntries[0].Message__c.contains(String.valueOf(testStatusCode)), 'Expected error debug log from BatchTrailheadEntityDeleteSync.execute().');
    }
}