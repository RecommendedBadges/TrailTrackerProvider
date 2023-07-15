@isTest
public class TrailmixTS extends TestSupport.DataGeneration  {
    public TrailmixTS(Map<String, Object> options) {
        super(options, Schema.SObjectType.trailheadapp__Trailmix__c.getKeyPrefix());
    }

    public override List<sObject> generate() {
        List<trailheadapp__Trailmix__c> testTrailmixes = new List<trailheadapp__Trailmix__c>();

        for(Integer i = 0; i < this.numberToGenerate; i++) {
            testTrailmixes.add(new trailheadapp__Trailmix__c(
                Id = this.insertRecords ? null : this.generateRecordId(),
                Name = 'Test Trailmix ' + i,
                trailheadapp__Created_By_Profile__c = 'www.test.com',
                trailheadapp__External_Id__c = 'Test Trailmix ' + i,
                trailheadapp__Slug__c = 'Test_Trailmix_' + i,
                trailheadapp__URL__c = 'www.test.com'
            ));
        }
        
        if(this.insertRecords) insert testTrailmixes;
        this.records = new Map<Id, sObject>(testTrailmixes);
        return this.returnCreatedRecords ? testTrailmixes : null;
    }
}