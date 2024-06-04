@isTest
public class TrailheadEntityUpdateEventTS extends TestSupport.DataGeneration {
    /**
     * Determines if UpdatedFields__c value is generated before each call to generate().
     */    
    public Boolean generateUpdatedFields {get; set;}

    @SuppressWarnings('PMD.ApexDoc')
    public TrailheadEntityUpdateEventTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public TrailheadEntityUpdateEventTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'TrailheadEntityUpdateEvent__e';
        this.generateRecordIDs = false;
        this.generateUpdatedFields = options.containsKey('generateUpdatedFields') ? Boolean.valueOf(options.get('generateUpdatedFields')) : true;
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            TrailheadEntityUpdateEvent__e.APIName__c => new CounterSuffixField(TrailheadEntityUpdateEvent__e.APIName__c, 'Test_Entity_'),
            TrailheadEntityUpdateEvent__e.EntityType__c => new ControlledValueField(
                TrailheadEntityUpdateEvent__e.EntityType__c,
                PicklistValueManager.getFieldValues(TrailheadEntityUpdate__c.getSObjectType(), TrailheadEntityUpdate__c.EntityType__c)
            )
        };
    }


    public override List<sObject> generate() {
        if(this.generateUpdatedFields) {
            List<String> updatedFields = new List<String>();
            List<String> trackedFields = PicklistValueManager.getFieldValues(TrailheadEntityUpdate__c.getSObjectType(), TrailheadEntityUpdate__c.UpdatedFields__c);
            String fieldName;
            for(Schema.SObjectField field : this.specsByField.keySet()) {
                fieldName = field.getDescribe().getName();
                if(trackedFields.contains(fieldName)) {
                    updatedFields.add(fieldName);
                }
            }
            this.setFieldSpec(new TestSupport.TestDataField(TrailheadEntityUpdate__c.UpdatedFields__c, String.join(updatedFields, ';')));
        }
        return super.generate();
    }
}