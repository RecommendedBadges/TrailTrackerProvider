List<trailheadapp__Badge__c> archivedBadges = [SELECT Id FROM trailheadapp__Badge__c WHERE trailheadapp__Archived__c = true];
List<trailheadapp__Trail__c> archivedTrails = [SELECT Id FROM trailheadapp__Trail__c WHERE trailheadapp__Archived__c = true];
delete archivedBadges;
delete archivedTrails;
Database.emptyRecycleBin(archivedBadges);
Database.emptyRecycleBin(archivedTrails);

List<trailheadapp__Trailmix__c> trailmixes = [SELECT Id FROM trailheadapp__Trailmix__c];
delete trailmixes;
Database.emptyRecycleBin(trailmixes);

/*List<trailheadapp__Debug_Log__c> debugLogs = [SELECT Id FROM trailheadapp__Debug_Log__c];
delete debugLogs;
Database.emptyRecycleBin(debugLogs);*/