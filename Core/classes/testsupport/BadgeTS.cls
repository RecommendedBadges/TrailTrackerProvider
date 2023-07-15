@isTest
public class BadgeTS extends TestSupport.DataGeneration  {
    public final Boolean includeArchivedBadges;
    public final Boolean includeBadgeProducts;
    public final Boolean includeBadgesToKeep;
    public final List<String> badgeProducts;
    public final List<String> badgesToKeep;

    public Map<String, sObject> modifiedBadgesByAPIName {
        get {
            if(this.modifiedBadgesByAPIName == null) {
                this.modifiedBadgesByAPIName = new Map<String, sObject>();
                for(sObject modifiedRecord : this.modifiedRecords.values()) {
                    this.modifiedBadgesByAPIName.put(String.valueOf(modifiedRecord.get('trailheadapp__API_Name__c')), modifiedRecord);
                }
            }
            return this.modifiedBadgesByAPIName;
        }
        private set;
    }

    // lazy loaded static variables to hold possible picklist values
    private static final List<String> LEVELS {
        get {
            if(LEVELS == null) {
                LEVELS = new List<String>();
                for(Schema.PicklistEntry pe : trailheadapp__Badge__c.trailheadapp__Level__c.getDescribe().getPicklistValues()) {
                    LEVELS.add(pe.getValue());
                }
            }
            return LEVELS;
        }
        set;
    }

    private static final List<String> TYPES {
        get {
            if(TYPES == null) {
                TYPES = new List<String>();
                for(Schema.PicklistEntry pe : trailheadapp__Badge__c.trailheadapp__Type__c.getDescribe().getPicklistValues()) {
                    TYPES.add(pe.getValue());
                }
            }
            return TYPES;
        }
        set;
    }

    private static final Map<String, List<String>> PICKLIST_VALUES_BY_FIELD {
        get {
            if(PICKLIST_VALUES_BY_FIELD == null) {
                PICKLIST_VALUES_BY_FIELD = new Map<String, List<String>>{
                    trailheadapp__Badge__c.trailheadapp__Type__c.getDescribe().getName() => TYPES,
                    trailheadapp__Badge__c.trailheadapp__Level__c.getDescribe().getName() => LEVELS
                };
            }
            return PICKLIST_VALUES_BY_FIELD;
        }
        set;
    }

    public BadgeTS(Map<String, Object> options) {
        super(options, Schema.SObjectType.trailheadapp__Badge__c.getKeyPrefix());
        this.includeArchivedBadges = options.containsKey('includeArchivedBadges') ? Boolean.valueOf(options.get('includeArchivedBadges')) : false;
        this.includeBadgeProducts = options.containsKey('includeBadgeProducts') ? Boolean.valueOf(options.get('includeBadgeProducts')) : false;
        this.includeBadgesToKeep = options.containsKey('includeBadgesToKeep') ? Boolean.valueOf(options.get('includeBadgesToKeep')) : false;
        this.badgeProducts = options.containsKey('badgeProducts') && this.includeBadgeProducts ? (List<String>) options.get('badgeProducts') : null;
        this.badgesToKeep = options.containsKey('badgesToKeep') && this.includeBadgesToKeep ? (List<String>) options.get('badgesToKeep') : null;
    }

    public override List<sObject> generate() {
        List<trailheadapp__Badge__c> testBadges = new List<trailheadapp__Badge__c>();

        Boolean archived = false;
        for(Integer i = 0; i < this.numberToGenerate; i++) {
            testBadges.add(new trailheadapp__Badge__c(
                Id = this.insertRecords ? null : this.generateRecordId(),
                Name = 'Test Badge ' + i,
                trailheadapp__API_Name__c = 'Test_Badge_' + i,
                trailheadapp__Description__c = 'Test Description',
                trailheadapp__Level__c = this.getRandomPicklistValue(LEVELS),
                trailheadapp__Namespace__c = 'Test Namespace',
                trailheadapp__Type__c = this.getRandomPicklistValue(TYPES),
                trailheadapp__URL__c = 'www.test.com',
                trailheadapp__Icon__c = 'www.testicon.com',
                trailheadapp__Archived__c = this.includeArchivedBadges ? archived : false
            ));
            if(this.includeArchivedBadges) archived = !archived;
        }

        if(this.includeBadgeProducts) {
            for(String badgeProduct : this.badgeProducts) {
                testBadges.add(new trailheadapp__Badge__c(
                    Id = this.insertRecords ? null : this.generateRecordId(),
                    Name = badgeProduct + ' Badge',
                    trailheadapp__API_Name__c = badgeProduct + ' Badge',
                    trailheadapp__Description__c = 'Test Description',
                    trailheadapp__Level__c = this.getRandomPicklistValue(LEVELS),
                    trailheadapp__Namespace__c = 'Test Namespace',
                    trailheadapp__Type__c = this.getRandomPicklistValue(TYPES),
                    trailheadapp__URL__c = 'www.test.com',
                    trailheadapp__Icon__c = 'www.testicon.com',
                    trailheadapp__Products__c = badgeProduct
                ));
            }
        }

        if(this.includeBadgesToKeep) {
            for(String badgeToKeep : this.badgesToKeep) {
                testBadges.add(new trailheadapp__Badge__c(
                    Id = this.insertRecords ? null : this.generateRecordId(),
                    Name = badgeToKeep,
                    trailheadapp__API_Name__c = badgeToKeep,
                    trailheadapp__Description__c = 'Test Description',
                    trailheadapp__Level__c = this.getRandomPicklistValue(LEVELS),
                    trailheadapp__Namespace__c = 'Test Namespace',
                    trailheadapp__Type__c = this.getRandomPicklistValue(TYPES),
                    trailheadapp__URL__c = 'www.test.com',
                    trailheadapp__Icon__c = 'www.testicon.com'
                ));
            }
        }

        if(this.insertRecords) insert testBadges;
        this.records = new Map<Id, sObject>(testBadges);
        return this.returnCreatedRecords ? testBadges : null;
    }

    public BadgeTS changePicklistField(Schema.DescribeFieldResult fieldToChange) {
        if(PICKLIST_VALUES_BY_FIELD.containsKey(fieldToChange.getName()) == false) {
            throw new TestSupport.TSException('Cannot call changePicklistField() with unsupported picklist field.');
        }
        return (BadgeTS) this.changePicklistField(fieldToChange, PICKLIST_VALUES_BY_FIELD.get(fieldToChange.getName()));
    }
}