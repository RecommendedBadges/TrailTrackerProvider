@isTest
private class TrailTriggerHandler_Tests {
    @isTest
    private static void it_should_generate_events_for_tracked_trail_fields() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert trailGenerator.generate();

        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Level__c'}
        };

        Test.startTest();
        update trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Level__c).modifiedRecords;
        update trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Description__c, 'Changed description.').modifiedRecords;

        Assert.areEqual(
            3,
            Limits.getDmlStatements(),
            'Expected three DML statements - two for trail updates and one for Trailhead Entity Update Event publish on tracked field.'
        );
        Assert.areEqual(
            trailGenerator.records.size() * 3,
            Limits.getDmlRows(),
            'Expected 600 DML rows - 400 from trail updates and 200 from Trailhead Entity Update Event publish on tracked field.'
        );
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Expected Trailhead Entity Events to publish successfully.');
    }

    @isTest
    private static void it_should_ignore_changes_to_archived_trails() {
        TrailTS trailGenerator = new TrailTS(
            new Map<String, Object>{'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__Archived__c, true)}    
        );
        insert trailGenerator.generate();

        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Level__c'}
        };

        Test.startTest();
        update trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Level__c).modifiedRecords;
        update trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__URL__c, 'www.newtest.com').modifiedRecords;

        Assert.areEqual(
            2, 
            Limits.getDmlStatements(), 
            'Expected two DML statements - one for each trail update.'
        );
        Assert.areEqual(
            trailGenerator.records.size() * 2,
            Limits.getDmlRows(),
            'Expected 400 DML rows - all from trail updates.'
        );
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Did not expect errors when there are no Trailhead Entity Events to publish.');
    }

    @isTest
    private static void it_should_generate_delete_events_for_trails_being_archived() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert trailGenerator.generate();

        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Level__c'}
        };

        Test.startTest();
        update trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Level__c).changeField(trailheadapp__Trail__c.trailheadapp__Archived__c, true).modifiedRecords;

        Assert.areEqual(
            2, 
            Limits.getDmlStatements(), 
            'Expected two DML statements - one for Trail updates and one for Trailhead Entity Event publish on Trail being archived.'
        );
        Assert.areEqual(
            trailGenerator.records.size() * 2,
            Limits.getDmlRows(),
            'Expected 400 DML rows - 200 from Trail updates and 200 from Trailhead Entity Event publish on Trail being archived.'
        );
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Expected Trailhead Entity Events to publish successfully.');
    }
}