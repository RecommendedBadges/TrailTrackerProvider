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
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Assert.areEqual(badgeGenerator.modifiedRecords.size(), trailheadEntityEvents.size(), 'Expected one Trailhead Entity Event for each changed Badge.');
        Map<String, trailheadapp__Badge__c> modifiedBadgesByAPIName = badgeGenerator.modifiedBadgesByAPIName;
        trailheadapp__Badge__c badge;
        for(TrailheadEntityEvent__e ev : trailheadEntityEvents) {
            badge = modifiedBadgesByAPIName.get(ev.APIName__c);
            Assert.areEqual('trailheadapp__Badge__c', ev.EntityType__c, 'Expected Trailhead Entity Event to have Entity Type of trailheadapp__Badge__c.');
            Assert.areEqual('update', ev.Operation__c, 'Expected Trailhead Entity Event to have operation set to update.');
            Assert.areEqual(badge.trailheadapp__Type__c, ev.Type__c, 'Expected Trailhead Entity Event to reflect change to tracked Badge field.');
            Assert.areEqual(badge.trailheadapp__URL__c, ev.URL__c, 'Expected Trailhead Entity Event to reflect change to tracked Badge field.');
            Assert.areEqual(
                new Set<String>{'APIName__c', 'EntityType__c', 'Operation__c', 'Products__c', 'Type__c', 'URL__c', 'UpdatedFields__c'},
                ev.getPopulatedFieldsAsMap().keySet(),
                'Trailhead Entity Event should only contain data about changed fields.'
            );
            Assert.isTrue(
                new Set<String>('Products__c;Type__c;URL__c'.split(';')).equals(new Set<String>(ev.UpdatedFields__c.split(';'))),
                'Expected Trailhead Entity Event to reflect tracked fields that changed.'
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
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Assert.areEqual(trailGenerator.modifiedRecords.size(), trailheadEntityEvents.size(), 'Expected one Trailhead Entity Event for each changed Trail.');
        Map<String, trailheadapp__Trail__c> modifiedTrailsByAPIName = trailGenerator.modifiedTrailsByAPIName;
        for(TrailheadEntityEvent__e ev : trailheadEntityEvents) {
            Assert.areEqual('trailheadapp__Trail__c', ev.EntityType__c, 'Expected Trailhead Entity Event to have Entity Type of trailheadapp__Trail__c.');
            Assert.areEqual(modifiedTrailsByAPIName.get(ev.APIName__c).trailheadapp__Description__c, ev.Description__c, 'Expected Trailhead Entity Event to reflect change to tracked Trail field.');
            Assert.areEqual('update', ev.Operation__c, 'Expected Trailhead Entity Event to have operation set to update.');
            Assert.areEqual(
                new Set<String>{'APIName__c', 'EntityType__c', 'Description__c', 'Level__c', 'Operation__c', 'Products__c', 'UpdatedFields__c'},
                ev.getPopulatedFieldsAsMap().keySet(),
                'Trailhead Entity Event should only contain data about changed fields.'
            );
            Assert.isTrue(
                new Set<String>('Description__c;Level__c;Products__c'.split(';')).equals(new Set<String>(ev.UpdatedFields__c.split(';'))),
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
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityEvents.size(), 'No events expected when changing non-tracked Badge field.');
    }

    @isTest
    private static void it_should_ignore_changes_to_non_tracked_trail_fields() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{});
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Roles__c, 'Example role.');

        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(trailGenerator.modifiedRecords), new Map<Id, sObject>(trailGenerator.records), 'trailheadapp__Trail__c');

        Test.startTest();
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityEvents.size(), 'No events expected when changing non-tracked Trail field.');
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
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityEvents.size(), 'No events expected when changing tracked fields on archived Badges.');
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
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Assert.areEqual(0, trailheadEntityEvents.size(), 'No events expected when changing archived Trails.');
    }

    @isTest
    private static void it_should_generate_delete_events_for_badges_being_archived() {
        BadgeTS badgeGenerator = new BadgeTS(new Map<String, Object>{});
        badgeGenerator.generate();
        badgeGenerator.changeField(trailheadapp__Badge__c.trailheadapp__Level__c).changeField(trailheadapp__Badge__c.trailheadapp__Archived__c, true);
    

        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(badgeGenerator.modifiedRecords), new Map<Id, sObject>(badgeGenerator.records), 'trailheadapp__Badge__c');
        TrailheadEntities.trackedFieldsByObject =  new Map<String, List<String>>{'trailheadapp__Badge__c' => new List<String>{'trailheadapp__Level__c'}};

        Test.startTest();
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();

        Set<String> badgeAPINames = badgeGenerator.modifiedBadgesByAPIName.keySet();
        Assert.areEqual(badgeGenerator.modifiedRecords.size(), trailheadEntityEvents.size(), 'Expected one Trailhead Entity Event for each changed Badge.');
        for(TrailheadEntityEvent__e ev : trailheadEntityEvents) {
            Assert.areEqual('delete', ev.Operation__c, 'Expected delete events to be generated for Badges being archived.');
            Assert.areEqual('trailheadapp__Badge__c', ev.EntityType__c, 'Expected delete events to be generated for Badges being archived.');
            Assert.isTrue(badgeAPINames.contains(ev.APIName__c), 'Expected delete events to be generated for Badges being archived.');
            Assert.areEqual(
                new Set<String>{'APIName__c', 'EntityType__c', 'Operation__c'},
                ev.getPopulatedFieldsAsMap().keySet(),
                'Expected only required fields to be populated.'
            );
        }
    }

    @isTest
    private static void it_should_generate_delete_events_for_trails_being_archived() {
        TrailTS trailGenerator = new TrailTS(new Map<String, Object>{});
        trailGenerator.generate();
        trailGenerator.changeField(trailheadapp__Trail__c.trailheadapp__Level__c).changeField(trailheadapp__Trail__c.trailheadapp__Archived__c, true);
    

        TrailheadEntities te = new TrailheadEntities(new Map<Id, sObject>(trailGenerator.modifiedRecords), new Map<Id, sObject>(trailGenerator.records), 'trailheadapp__Trail__c');
        TrailheadEntities.trackedFieldsByObject =  new Map<String, List<String>>{'trailheadapp__Trail__c' => new List<String>{'trailheadapp__Level__c'}};

        Test.startTest();
        List<TrailheadEntityEvent__e> trailheadEntityEvents = te.generateTrailheadEntityEvents();
        Test.stopTest();


        Set<String> trailAPINames = trailGenerator.modifiedTrailsByAPIName.keySet();
        Assert.areEqual(trailGenerator.modifiedRecords.size(), trailheadEntityEvents.size(), 'Expected one Trailhead Entity Event for each changed Trail.');
        for(TrailheadEntityEvent__e ev : trailheadEntityEvents) {
            Assert.areEqual('delete', ev.Operation__c, 'Expected delete events to be generated for Trails being archived.');
            Assert.areEqual('trailheadapp__Trail__c', ev.EntityType__c, 'Expected delete events to be generated for Trails being archived.');
            Assert.isTrue(trailAPINames.contains(ev.APIName__c), 'Expected delete events to be generated for Trails being archived.');
            Assert.areEqual(
                new Set<String>{'APIName__c', 'EntityType__c', 'Operation__c'},
                ev.getPopulatedFieldsAsMap().keySet(),
                'Expected only required fields to be populated.'
            );
        }
    }
}