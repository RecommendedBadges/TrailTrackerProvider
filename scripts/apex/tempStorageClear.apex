List<trailheadapp__User_Badge__c> userBadges = [SELECT Id FROM trailheadapp__User_Badge__c];
delete userBadges;
Database.emptyRecycleBin(userBadges);