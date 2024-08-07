@isTest
public class TrailheadEntityDeleteTS extends TestSupport.DataGeneration {
    /**
     * Default constructor
     * @param options DataGeneration options
     */
    public TrailheadEntityDeleteTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    /**
     * Overridden constructor with custom field specs
     * @param options DataGeneration options
     * @param fieldSpecs Custom field specs
     */    
    public TrailheadEntityDeleteTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'TrailheadEntityDelete__c';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            TrailheadEntityDelete__c.APIName__c => new CounterSuffixField(TrailheadEntityDelete__c.APIName__c, 'Test_Delete_'),
            TrailheadEntityDelete__c.EntityType__c => new RandomPicklistValueField(TrailheadEntityDelete__c.EntityType__c)
        };
    }
}