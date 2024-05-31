@isTest
public class TrailheadEntityUpdateEventTS extends TestSupport.DataGeneration {
    public TrailheadEntityUpdateEventTS(Map<String, Object> options) {
        super(options);
        this.S_OBJECT_TYPE = 'TrailheadEntityUpdateEvent__e';
    }

    public TrailheadEntityUpdateEventTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'TrailheadEntityUpdateEvent__e';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            TrailheadEntityUpdateEvent__e.APIName__c => new CounterSuffixField(TrailheadEntityUpdateEvent__e.APIName__c, 'Test_Entity_')
        };
    } 
}