@isTest
public class DebugLogTS extends TestSupport.DataGeneration  {
    public DebugLogTS(Map<String, Object> options) {
        super(options, Schema.SObjectType.trailheadapp__Debug_Log__c.getKeyPrefix());
    }

    public override List<sObject> generate() {
        List<trailheadapp__Debug_Log__c> testDebugLogs = new List<trailheadapp__Debug_Log__c>();
        for(Integer i = 0; i < this.numberToGenerate; i++) {
            testDebugLogs.add(new trailheadapp__Debug_Log__c(
                Id = this.insertRecords ? null : this.generateRecordId(),
                trailheadapp__Class__c = 'Test ' + i,
                trailheadapp__Datetime__c = DateTime.now(),
                trailheadapp__Message__c = 'Test Message ' + i,
                trailheadapp__Method__c = 'Test Method ' + i,
                trailheadapp__Severity__c = 'Test ' + i,
                trailheadapp__Transaction__c = 'Test Transaction ' + i
            ));
        }
        
        if(this.insertRecords) insert testDebugLogs;
        this.records = new Map<Id, sObject>(testDebugLogs);
        return this.returnCreatedRecords ? testDebugLogs : null;
    }
}