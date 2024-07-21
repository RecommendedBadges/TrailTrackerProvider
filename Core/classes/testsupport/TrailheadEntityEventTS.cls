@isTest
public class TrailheadEntityEventTS extends TestSupport.DataGeneration {
    /**
     * Determines if UpdatedFields__c value is generated before each call to generate().
     */    
    public Boolean generateUpdatedFields {get; set;}

    /**
     * Holds Trailhead Entity Events by API name.
     */
    public Map<String, TrailheadEntityEvent__e> eventsByAPIName {
        get {
            if(this.eventsByAPIName == null) {
                this.eventsByAPIName = new Map<String, TrailheadEntityEvent__e>();
                for(sObject record : this.records) {
                    this.eventsByAPIName.put(String.valueOf(record.get('APIName__c')), (TrailheadEntityEvent__e) record);
                }
            }
            return this.eventsByAPIName;
        }
        set;
    } 

    /**
     * Default constructor
     * @param options DataGeneration options
     */
    public TrailheadEntityEventTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    /**
     * Overridden constructor with custom field specs
     * @param options DataGeneration options
     * @param fieldSpecs Custom field specs
     */
    public TrailheadEntityEventTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'TrailheadEntityEvent__e';
        this.generateRecordIDs = false;
        this.generateUpdatedFields = options.containsKey('generateUpdatedFields') ? Boolean.valueOf(options.get('generateUpdatedFields')) : true;
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField> {
            TrailheadEntityEvent__e.APIName__c => new CounterSuffixField(TrailheadEntityEvent__e.APIName__c, 'Test_Entity_'),
            TrailheadEntityEvent__e.EntityType__c => new ControlledValueField(
                TrailheadEntityEvent__e.EntityType__c,
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