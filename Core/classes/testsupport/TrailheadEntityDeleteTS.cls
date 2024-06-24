@isTest
public class TrailheadEntityDeleteTS extends TestSupport.DataGeneration {
    @SuppressWarnings('PMD.ApexDoc')
    public TrailheadEntityDeleteTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
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