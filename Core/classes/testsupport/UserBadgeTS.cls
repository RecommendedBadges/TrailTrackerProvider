@isTest
public class UserBadgeTS extends TestSupport.DataGeneration  {
    public final List<trailheadapp__Badge__c> BADGES;

    public UserBadgeTS(Map<String, Object> options, List<trailheadapp__Badge__c> badges) {
        super(options, Schema.SObjectType.trailheadapp__User_Badge__c.getKeyPrefix());
        this.BADGES = badges;
    }

    public override List<sObject> generate() {
        List<User> users = [SELECT Id FROM User];
        List<trailheadapp__User_Badge__c> testUserBadges = new List<trailheadapp__User_Badge__c>();
        for(trailheadapp__Badge__c badge : this.BADGES) {
            testUserBadges.add(new trailheadapp__User_Badge__c(
                Id = this.insertRecords ? null : this.generateRecordId(),
                trailheadapp__Badge__c = badge.Id,
                trailheadapp__User__c = users[0].Id
            ));
        }
        
        if(this.insertRecords) insert testUserBadges;
        this.records = new Map<Id, sObject>(testUserBadges);
        return this.returnCreatedRecords ? testUserBadges : null;
    }
}
