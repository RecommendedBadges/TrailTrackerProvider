@isTest
private class BadgeTriggerHandler_Tests {
    @isTest
    private static void it_should_generate_events_for_tracked_badge_fields() {
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
            'Expected three DML statements - two for badge updates and one for Trailhead Entity Update Event publish on tracked field.'
        );
        Assert.areEqual(
            600,
            Limits.getDmlRows(),
            'Expected 600 DML rows - 400 from badge updates and 200 from Trailhead Entity Update Event publish on tracked field.'
        );
        Test.stopTest();
    }
}