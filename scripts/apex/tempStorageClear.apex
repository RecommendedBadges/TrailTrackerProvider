List<trailheadapp__User_Badge__c> userBadges = [SELECT Id FROM trailheadapp__User_Badge__c];
List<trailheadapp__User_Trailmix__c> userTrailmixes = [SELECT Id FROM trailheadapp__User_Trailmix__c];
delete userBadges;
delete userTrailmixes;
Database.emptyRecycleBin(userBadges);
Database.emptyRecycleBin(userTrailmixes);