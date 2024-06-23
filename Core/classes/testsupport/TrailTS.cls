@isTest
public class TrailTS extends TestSupport.DataGeneration  {
    /**
     * Holds changed badges by value of trailheadapp__API_Name__c.
     */    
    public Map<String, trailheadapp__Trail__c> modifiedTrailsByAPIName {
        get {
            if(this.modifiedTrailsByAPIName == null) {
                this.modifiedTrailsByAPIName = new Map<String, trailheadapp__Trail__c>();
                for(sObject modifiedRecord : this.modifiedRecords) {
                    this.modifiedTrailsByAPIName.put(String.valueOf(modifiedRecord.get('trailheadapp__API_Name__c')), (trailheadapp__Trail__c) modifiedRecord);
                }
            }
            return this.modifiedTrailsByAPIName;
        }
        private set;
    }

    @SuppressWarnings('PMD.ApexDoc')
    public TrailTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public TrailTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'trailheadapp__Trail__c';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            trailheadapp__Trail__c.Name => new CounterSuffixField(trailheadapp__Trail__c.Name, 'Test Trail '),
            trailheadapp__Trail__c.trailheadapp__API_Name__c => new CounterSuffixField(trailheadapp__Trail__c.trailheadapp__API_Name__c, 'Test_Trail_'),
            trailheadapp__Trail__c.trailheadapp__Description__c => new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__Description__c, 'Test Description'),
            trailheadapp__Trail__c.trailheadapp__Level__c => new RandomPicklistValueField(trailheadapp__Trail__c.trailheadapp__Level__c),
            trailheadapp__Trail__c.trailheadapp__Namespace__c => new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__Namespace__c, 'Test Namespace'),
            trailheadapp__Trail__c.trailheadapp__URL__c => new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__URL__c, 'www.test.com'),
            trailheadapp__Trail__c.trailheadapp__Icon__c => new TestSupport.TestDataField(trailheadapp__Trail__c.trailheadapp__Icon__c, 'www.testicon.com')
        };
    }
}