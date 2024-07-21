@isTest
public class TrailmixTS extends TestSupport.DataGeneration {
    /**
     * Default constructor
     * @param options DataGeneration options
     */
    public TrailmixTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    /**
     * Overridden constructor with custom field specs
     * @param options DataGeneration options
     * @param fieldSpecs Custom field specs
     */    
    public TrailmixTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'trailheadapp__Trailmix__c';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            trailheadapp__Trailmix__c.Name => new CounterSuffixField(trailheadapp__Trailmix__c.Name, 'Test Trailmix '),
            trailheadapp__Trailmix__c.trailheadapp__Created_By_Profile__c => new TestSupport.TestDataField(
                trailheadapp__Trailmix__c.trailheadapp__Created_By_Profile__c, 'www.test.com'
            ),
            trailheadapp__Trailmix__c.trailheadapp__External_Id__c => new CounterSuffixField(trailheadapp__Trailmix__c.trailheadapp__External_Id__c, 'Test_Trailmix_'),
            trailheadapp__Trailmix__c.trailheadapp__Slug__c => new CounterSuffixField(trailheadapp__Trailmix__c.trailheadapp__Slug__c, 'Test_Trailmix_'),
            trailheadapp__Trailmix__c.trailheadapp__URL__c => new TestSupport.TestDataField(trailheadapp__Trailmix__c.trailheadapp__URL__c, 'www.test.com')
        };
    }
}