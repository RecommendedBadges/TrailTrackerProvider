@isTest(isParallel=true)
private class TrailheadEntities_Tests {
    @isTest
    private static void it_should_generate_events_for_tracked_badge_fields() {
        BadgeTS badgeGenerator = new BadgeTS(
            new Map<String, Object>{}, 
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__Products__c, 'Test products.')}
        );
        badgeGenerator.generate();
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__URL__c, 'www.modifiedtest.com')
            .changeField(trailheadapp__Badge__c.trailheadapp__Roles__c, 'Example roles.')
            .changeField(trailheadapp__Badge__c.trailheadapp__Type__c)
            .changeField(trailheadapp__Badge__c.trailheadapp__Products__c, null);

        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(badgeGenerator.modifiedRecords), new Map<Id, sObject>(badgeGenerator.records), 'trailheadapp__Badge__c');
        TrailheadEntities.trackedFieldsByObject = new Map<String, List<String>>{
            'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Type__c', 'trailheadapp__Products__c', 'trailheadapp__URL__c'}
        };

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Map<String, sObject> modifiedBadgesByAPIName = badgeGenerator.modifiedBadgesByAPIName;
        for(TrailheadEntityUpdateEvent__e teue : trailheadEntityUpdateEvents) {
            Assert.areEqual(
                'trailheadapp__Badge__c',
                teue.EntityType__c,
                'Expected Trailhead Entity Update Event to have Entity Type of trailheadapp__Badge__c.'
            );
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
                new Set<String>{'APIName__c', 'EntityType__c', 'Products__c', 'Type__c', 'URL__c', 'UpdatedFields__c'},
                teue.getPopulatedFieldsAsMap().keySet(),
                'Trailhead Entity Update Event should only contain data about changed fields.'
            );
            Assert.isTrue(
                new Set<String>('Products__c;Type__c;URL__c'.split(';')).equals(new Set<String>(teue.UpdatedFields__c.split(';'))),
                'Expected Trailhead Entity Update Event to reflect tracked fields that changed.'
            );
        }
    }

    @isTest
    private static void it_should_generate_events_for_tracked_trail_fields() {
        TrailTS trailGenerator = new TrailTS(
            new Map<String, Object>{},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__Products__c, 'Test products.')}
        );
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Description__c, 'Changed description.')
            .changeField(trailheadapp__Trail__c.trailheadapp__Level__c)
            .changeField(trailheadapp__Trail__c.trailheadapp__Products__c, null);
        
        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(trailGenerator.modifiedRecords), new Map<Id, sObject>(trailGenerator.records), 'trailheadapp__Trail__c');
        TrailheadEntities.trackedFieldsByObject =  new Map<String, List<String>>{
            'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Description__c', 'trailheadapp__Level__c', 'trailheadapp__Products__c'}
        };

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Map<String, sObject> modifiedTrailsByAPIName = trailGenerator.modifiedTrailsByAPIName;
        for(TrailheadEntityUpdateEvent__e teue : trailheadEntityUpdateEvents) {
            Assert.areEqual(
                'trailheadapp__Trail__c',
                teue.EntityType__c,
                'Expected Trailhead Entity Update Event to have Entity Type of trailheadapp__Trail__c.'
            );
            Assert.areEqual(
                modifiedTrailsByAPIName.get(teue.APIName__c).get('trailheadapp__Description__c'), 
                teue.Description__c, 
                'Expected Trailhead Entity Update Event to reflect change to tracked Trail field.'
            );
            Assert.areEqual(
                new Set<String>{'APIName__c', 'EntityType__c', 'Description__c', 'Level__c', 'Products__c', 'UpdatedFields__c'},
                teue.getPopulatedFieldsAsMap().keySet(),
                'Trailhead Entity Update Event should only contain data about changed fields.'
            );
            Assert.isTrue(
                new Set<String>('Description__c;Level__c;Products__c'.split(';')).equals(new Set<String>(teue.UpdatedFields__c.split(';'))),
                'Expected Trailhead Entity Update Event to reflect tracked fields that changed.'
            );
        }
    }

    @isTest
    private static void it_should_ignore_changes_to_non_tracked_badge_fields() {
        BadgeTS badgeGenerator = new BadgeTS(new Map<String, Object>{});
        badgeGenerator.generate();
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Roles__c, 'Example role.');

        TrailheadEntities te = new TrailheadEntities(new Map<Id,sObject>(badgeGenerator.modifiedRecords), new Map<Id, sObject>(badgeGenerator.records), 'trailheadapp__Badge__c');

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityUpdateEvents.size(), 'No events expected when changing non-tracked Badge field.');
    }

    @isTest
    private static void it_should_ignore_changes_to_non_tracked_trail_fields() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{});
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Roles__c, 'Example role.');

        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(trailGenerator.modifiedRecords), new Map<Id, sObject>(trailGenerator.records), 'trailheadapp__Trail__c');

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityUpdateEvents.size(), 'No events expected when changing non-tracked Trail field.');
    }

    @isTest
    private static void it_should_ignore_changes_to_archived_badges() {
        BadgeTS badgeGenerator = new BadgeTS(
            new Map<String, Object>{},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__Archived__c, true)}
        );
        badgeGenerator.generate();
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Type__c);

        TrailheadEntities te = new TrailheadEntities(new Map<Id,sObject>(badgeGenerator.modifiedRecords), new Map<Id, sObject>(badgeGenerator.records), 'trailheadapp__Badge__c');
        TrailheadEntities.trackedFieldsByObject =  new Map<String, List<String>>{'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Type__c'}};

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityUpdateEvents.size(), 'No events expected when changing tracked fields on archived Badges.');
    }

    @isTest
    private static void it_should_ignore_changes_to_archived_trails() {
        TrailTS trailGenerator = new TrailTS(
            new Map<String, Object>{},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__Archived__c, true)}
        );
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Level__c);
    

        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(trailGenerator.modifiedRecords), new Map<Id, sObject>(trailGenerator.records), 'trailheadapp__Trail__c');
        TrailheadEntities.trackedFieldsByObject =  new Map<String, List<String>>{'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Level__c'}};

        Test.startTest();
        List<TrailheadEntityUpdateEvent__e> trailheadEntityUpdateEvents = te.generateUpdateEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityUpdateEvents.size(), 'No events expected when changing archived Trails.');
    }
}