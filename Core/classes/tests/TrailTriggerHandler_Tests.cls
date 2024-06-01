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
            600,
            Limits.getDmlRows(),
            'Expected 600 DML rows - 400 from trail updates and 200 from Trailhead Entity Update Event publish on tracked field.'
        );
        Test.stopTest();
    }
}