@isTest
public class DebugLogTS extends TestSupport.DataGeneration  {
    /**
     * Default constructor
     * @param options DataGeneration options
     */
    public DebugLogTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    /**
     * Overridden constructor with custom field specs
     * @param options DataGeneration options
     * @param fieldSpecs Custom field specs
     */    
    public DebugLogTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'trailheadapp__Debug_Log__c';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            trailheadapp__Debug_Log__c.trailheadapp__Class__c => new CounterSuffixField(trailheadapp__Debug_Log__c.trailheadapp__Class__c, 'Test'),
            trailheadapp__Debug_Log__c.trailheadapp__Datetime__c => new DateTimeField(trailheadapp__Debug_Log__c.trailheadapp__Datetime__c, DateTime.now()),
            trailheadapp__Debug_Log__c.trailheadapp__Message__c => new CounterSuffixField(trailheadapp__Debug_Log__c.trailheadapp__Message__c, 'Test message '),
            trailheadapp__Debug_Log__c.trailheadapp__Method__c => new CounterSuffixField(trailheadapp__Debug_Log__c.trailheadapp__Method__c, 'testMethod'),
            trailheadapp__Debug_Log__c.trailheadapp__Severity__c => new CounterSuffixField(trailheadapp__Debug_Log__c.trailheadapp__Severity__c, 'Test '),
            trailheadapp__Debug_Log__c.trailheadapp__Transaction__c => new CounterSuffixField(trailheadapp__Debug_Log__c.trailheadapp__Transaction__c, '')
        };
    }
}