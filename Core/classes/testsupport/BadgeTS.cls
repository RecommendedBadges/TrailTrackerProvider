@isTest
public class BadgeTS extends TestSupport.DataGeneration  {
    /**
     * Holds changed badges by value of trailheadapp__API_Name__c.
     */    
    public Map<String, trailheadapp__Badge__c> modifiedBadgesByAPIName {
        get {
            if(this.modifiedBadgesByAPIName == null) {
                this.modifiedBadgesByAPIName = new Map<String, trailheadapp__Badge__c>();
                for(sObject modifiedRecord : this.modifiedRecords) {
                    this.modifiedBadgesByAPIName.put(String.valueOf(modifiedRecord.get('trailheadapp__API_Name__c')), (trailheadapp__Badge__c) modifiedRecord);
                }
            }
            return this.modifiedBadgesByAPIName;
        }
        private set;
    }

    @SuppressWarnings('PMD.ApexDoc')
    public BadgeTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public BadgeTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'trailheadapp__Badge__c';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            trailheadapp__Badge__c.Name => new CounterSuffixField(trailheadapp__Badge__c.Name, 'Test Badge '),
            trailheadapp__Badge__c.trailheadapp__API_Name__c => new CounterSuffixField(trailheadapp__Badge__c.trailheadapp__API_Name__c, 'Test_Badge_'),
            trailheadapp__Badge__c.trailheadapp__Description__c => new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__Description__c, 'Test Description'),
            trailheadapp__Badge__c.trailheadapp__Level__c => new RandomPicklistValueField(trailheadapp__Badge__c.trailheadapp__Level__c),
            trailheadapp__Badge__c.trailheadapp__Namespace__c => new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__Namespace__c, 'Test Namespace'),
            trailheadapp__Badge__c.trailheadapp__Type__c => new RandomPicklistValueField(trailheadapp__Badge__c.trailheadapp__Type__c),
            trailheadapp__Badge__c.trailheadapp__URL__c => new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__URL__c, 'www.test.com'),
            trailheadapp__Badge__c.trailheadapp__Icon__c => new TestSupport.TestDataField(trailheadapp__Badge__c.trailheadapp__Icon__c, 'ww.testicon.com')
        };
    }
}