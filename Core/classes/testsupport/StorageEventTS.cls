@isTest
public class StorageEventTS extends TestSupport.DataGeneration {
    /**
     * Default constructor
     * @param options DataGeneration options
     */
    public StorageEventTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    /**
     * Overridden constructor with custom field specs
     * @param options DataGeneration options
     * @param fieldSpecs Custom field specs
     */    
    public StorageEventTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'StorageEvent__e';
        this.generateRecordIDs = false;
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            StorageEvent__e.Action__c => new TestSupport.TestDataField(StorageEvent__e.Action__c, 'delete')
        };
    }
}