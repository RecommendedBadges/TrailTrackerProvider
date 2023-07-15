@isTest(isParallel=true)
private class TrailheadEntities_Tests {
    @isTest
    private static void it_should_generate_events_for_tracked_badge_fields() {
        BadgeTS badgeGenerator = new BadgeTS(new Map<String, Object>{
            'returnCreatedRecords' => false
        });
        badgeGenerator.generate();
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__URL__c.getDescribe(), 'www.modifiedtest.com');
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Roles__c.getDescribe(), 'Example roles.');
        badgeGenerator.changePicklistField(trailheadapp__Badge__c.trailheadapp__Type__c.getDescribe());
        
        TrailheadEntities te = new TrailheadEntities(badgeGenerator.modifiedRecords, badgeGenerator.records, 'trailheadapp__Badge__c');
        Map<String, List<String>> trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Type__c', 'trailheadapp__URL__c'}
        };
        TrailheadEntities.trackedFieldsByObject = trackedFieldsByObject;

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Map<String, sObject> modifiedBadgesByAPIName = badgeGenerator.modifiedBadgesByAPIName;
        for(TrailheadEntityUpdateEvent__e teue : trailheadEntityUpdateEvents) {
            Assert.areEqual(
                modifiedBadgesByAPIName.get(teue.APIName__c).get('trailheadapp__Type__c'), 
                teue.Type__c, 
                'Expected Trailhead Entity Update Event to reflect change to tracked Badge field.'
            );
            Assert.areEqual(
                modifiedBadgesByAPIName.get(teue.APIName__c).get('trailheadapp__URL__c'), 
                teue.URL__c,
                'Expected Trailhead Entity Update Event to reflect change to tracked Badge field.'
            );
            Assert.areEqual(
                new Set<String>{'APIName__c', 'Type__c', 'URL__c'},
                teue.getPopulatedFieldsAsMap().keySet(),
                'Trailhead Entity Update Event should only contain data about changed fields.'
            );
        }
    }

    @isTest
    private static void it_should_generate_events_for_tracked_trail_fields() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{
            'returnCreatedRecords' => false
        });
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Description__c.getDescribe(), 'Changed description.');
        trailGenerator.changePicklistField(trailheadapp__trail__c.trailheadapp__Level__c.getDescribe());

        TrailheadEntities te = new TrailheadEntities(trailGenerator.modifiedRecords, trailGenerator.records, 'trailheadapp__Trail__c');
        Map<String, List<String>> trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Description__c', 'trailheadapp__Level__c'}
        };
        TrailheadEntities.trackedFieldsByObject = trackedFieldsByObject;

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Map<String, sObject> modifiedTrailsByAPIName = trailGenerator.modifiedTrailsByAPIName;
        for(TrailheadEntityUpdateEvent__e teue : trailheadEntityUpdateEvents) {
            Assert.areEqual(
                modifiedTrailsByAPIName.get(teue.APIName__c).get('trailheadapp__Description__c'), 
                teue.Description__c, 
                'Expected Trailhead Entity Update Event to reflect change to tracked Trail field.'
            );
            Assert.areEqual(
                new Set<String>{'APIName__c', 'Description__c', 'Level__c'},
                teue.getPopulatedFieldsAsMap().keySet(),
                'Trailhead Entity Update Event should only contain data about changed fields.'
            );
        }
    }

    @isTest
    private static void it_should_ignore_changes_to_non_tracked_badge_fields() {
        BadgeTS badgeGenerator = new BadgeTS(new Map<String, Object>{
            'returnCreatedRecords' => false
        });
        badgeGenerator.generate();
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Roles__c.getDescribe(), 'Example role.');

        TrailheadEntities te = new TrailheadEntities(badgeGenerator.modifiedRecords, badgeGenerator.records, 'trailheadapp__Badge__c');

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityUpdateEvents.size(), 'No events expected when changing non-tracked Badge field.');
    }

    @isTest
    private static void it_should_ignore_changes_to_non_tracked_trail_fields() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{
            'returnCreatedRecords' => false
        });
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Roles__c.getDescribe(), 'Example role.');

        TrailheadEntities te = new TrailheadEntities(trailGenerator.modifiedRecords, trailGenerator.records, 'trailheadapp__Trail__c');

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityUpdateEvents.size(), 'No events expected when changing non-tracked Trail field.');
    }
}