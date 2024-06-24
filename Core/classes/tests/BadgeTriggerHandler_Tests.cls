@isTest
private class BadgeTriggerHandler_Tests {
    @isTest
    private static void it_should_generate_update_events_for_tracked_badge_fields() {
        BadgeTS badgeGenerator = new BadgeTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert badgeGenerator.generate();

        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Type__c'}
        };

        Test.startTest();
        update badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Type__c).modifiedRecords;
        update badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__URL__c, 'www.newtest.com').modifiedRecords;

        Assert.areEqual(
            3, 
            Limits.getDmlStatements(), 
            'Expected three DML statements - two for badge updates and one for Trailhead Entity Event publish on tracked field.'
        );
        Assert.areEqual(
            badgeGenerator.records.size() * 3,
            Limits.getDmlRows(),
            'Expected 600 DML rows - 400 from badge updates and 200 from Trailhead Entity Event publish on tracked field.'
        );
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Expected Trailhead Entity Events to publish successfully.');
    }

    @isTest
    private static void it_should_ignore_changes_to_archived_badges() {
        BadgeTS badgeGenerator = new BadgeTS(
            new Map<String, Object>{'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__Archived__c, true)}    
        );
        insert badgeGenerator.generate();

        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Type__c'}
        };

        Test.startTest();
        update badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Type__c).modifiedRecords;
        update badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__URL__c, 'www.newtest.com').modifiedRecords;

        Assert.areEqual(
            2, 
            Limits.getDmlStatements(), 
            'Expected two DML statements - one for each badge update.'
        );
        Assert.areEqual(
            badgeGenerator.records.size() * 2,
            Limits.getDmlRows(),
            'Expected 400 DML rows - all from badge updates.'
        );
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Did not expect errors when there are no Trailhead Entity Events to publish.');
    }

    @isTest
    private static void it_should_generate_delete_events_for_badges_being_archived() {
        BadgeTS badgeGenerator = new BadgeTS(new Map<String, Object>{'generateRecordIDs' => false});
        insert badgeGenerator.generate();

        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Type__c'}
        };

        Test.startTest();
        update badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Type__c).changeField(trailheadapp__Badge__c.trailheadapp__Archived__c, true).modifiedRecords;

        Assert.areEqual(
            2, 
            Limits.getDmlStatements(), 
            'Expected two DML statements - one for Badge updates and one for Trailhead Entity Event publish on Badge being archived.'
        );
        Assert.areEqual(
            badgeGenerator.records.size() * 2,
            Limits.getDmlRows(),
            'Expected 400 DML rows - 200 from Badge updates and 200 from Trailhead Entity Event publish on Badge being archived.'
        );
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Expected Trailhead Entity Events to publish successfully.');
    }
}