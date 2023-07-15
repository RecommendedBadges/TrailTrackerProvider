@isTest
public class TrailTS extends TestSupport.DataGeneration  {
    public Boolean includeArchivedTrails {get; set;}
    public Boolean includeTrailProducts {get; set;}
    public final List<String> TRAIL_PRODUCTS;

    public Map<String, sObject> modifiedTrailsByAPIName {
        get {
            if(this.modifiedTrailsByAPIName == null) {
                this.modifiedTrailsByAPIName = new Map<String, sObject>();
                for(sObject modifiedRecord : this.modifiedRecords.values()) {
                    this.modifiedTrailsByAPIName.put(String.valueOf(modifiedRecord.get('trailheadapp__API_Name__c')), modifiedRecord);
                }
            }
            return this.modifiedTrailsByAPIName;
        }
        private set;
    }
    // lazy loaded static variables to hold possible picklist values
    private static final List<String> LEVELS {
        get {
            if(LEVELS == null) {
                LEVELS = new List<String>();
                for(Schema.PicklistEntry pe : trailheadapp__Trail__c.trailheadapp__Level__c.getDescribe().getPicklistValues()) {
                    LEVELS.add(pe.getValue());
                }
            }
            return LEVELS;
        }
        set;
    }

    private static final Map<String, List<String>> PICKLIST_VALUES_BY_FIELD {
        get {
            if(PICKLIST_VALUES_BY_FIELD == null) {
                PICKLIST_VALUES_BY_FIELD = new Map<String, List<String>>{
                    trailheadapp__Trail__c.trailheadapp__Level__c.getDescribe().getName() => LEVELS
                };
            }
            return PICKLIST_VALUES_BY_FIELD;
        }
        set;
    }

    public TrailTS(Map<String, Object> options) {
        super(options, Schema.SObjectType.trailheadapp__Trail__c.getKeyPrefix());
        this.includeArchivedTrails = options.containsKey('includeArchivedTrails') ? Boolean.valueOf(options.get('includeArchivedTrails')) : false;
        this.includeTrailProducts = options.containsKey('includeTrailProducts') ? Boolean.valueOf(options.get('includeTrailProducts')) : false;
        this.TRAIL_PRODUCTS = options.containsKey('trailProducts') ? (List<String>) options.get('trailProducts') : null;
    }

    public override List<sObject> generate() {
        List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>();
        Boolean archived = false;

        for(Integer i = 0; i < this.numberToGenerate; i++) {
            testTrails.add(new trailheadapp__Trail__c(
                Id = this.insertRecords ? null : this.generateRecordId(),
                Name = 'Test Trail ' + i,
                trailheadapp__API_Name__c = 'Test_Trail_' + i,
                trailheadapp__Description__c = 'Test Description',
                trailheadapp__Level__c = this.getRandomPicklistValue(LEVELS),
                trailheadapp__Namespace__c = 'Test Namespace',
                trailheadapp__URL__c = 'www.test.com',
                trailheadapp__Icon__c = 'www.testicon.com',
                trailheadapp__Archived__c  =  this.includeArchivedTrails ? archived : false
            ));
            if(this.includeArchivedTrails) archived = !archived;
        }

        if(this.includeTrailProducts) {
            for(String trailProduct : this.TRAIL_PRODUCTS) {
                testTrails.add(new trailheadapp__Trail__c( 
                    Name = trailProduct + ' Trail ',
                    trailheadapp__API_Name__c = trailProduct + ' Trail ',
                    trailheadapp__Description__c='Test Description',
                    trailheadapp__Level__c=this.getRandomPicklistValue(LEVELS),
                    trailheadapp__Namespace__c='Test Namespace',
                    trailheadapp__Products__c = trailProduct,
                    trailheadapp__URL__c='www.test.com',
                    trailheadapp__Icon__c='www.testicon.com'
                ));
            }
        }

        if(this.insertRecords) insert testTrails;
        this.records = new Map<Id, sObject>(testTrails);
        return this.returnCreatedRecords ? testTrails : null;
    }

    public TrailTS changePicklistField(Schema.DescribeFieldResult fieldToChange) {
        if(PICKLIST_VALUES_BY_FIELD.containsKey(fieldToChange.getName()) == false) {
            throw new TestSupport.TSException('Cannot call changePicklistField() with unsupported picklist field.');
        }
        return (TrailTS) this.changePicklistField(fieldToChange, PICKLIST_VALUES_BY_FIELD.get(fieldToChange.getName()));
    }
}