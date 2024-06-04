@isTest
private class DebugLogTriggerHandler_Tests {
    private static final String BATCH_CLASS_NAME = 'BatchTrailheadEntityUpdateSync';
    private static final String ASYNC_JOB_TYPE = 'BatchApex';

    @isTest
    private static void it_should_enqueue_batch_job_after_sync_finished() {
        DebugLogTS debugLogGenerator = new DebugLogTS(new Map<String, Object>{'numberToGenerate' => 30, 'generateRecordIDs' => false});

        TrailheadEntityUpdate__c trailheadEntityUpdate = new TrailheadEntityUpdate__c(
            APIName__c = 'Test',
            EntityType__c = 'trailheadapp__Trail__c',
            Products__c = 'New products.',
            UpdatedFields__c = 'Products__c'
        );
        insert trailheadEntityUpdate;

        trailheadapp__Debug_Log__c syncFinishLog = new trailheadapp__Debug_Log__c(
            trailheadapp__Class__c = DebugLogTriggerHandler.SYNC_FINISHED_CLASS,
            trailheadapp__Method__c = DebugLogTriggerHandler.SYNC_FINISHED_METHOD,
            trailheadapp__Message__c = DebugLogTriggerHandler.SYNC_FINISHED_MESSAGE,
            trailheadapp__Severity__c = DebugLogTriggerHandler.SYNC_FINISHED_SEVERITY,
            trailheadapp__DateTime__c = DateTime.now(),
            trailheadapp__Transaction__c = 'current transaction'
        );

        Test.startTest();
        insert debugLogGenerator.generate();

        Assert.areEqual(
            0, 
            [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE].size(), 
            'Did not expect BatchTrailheadEntityUpdateSync to be scheduled without sync job finishing first.'
        );

        insert syncFinishLog;
        Test.stopTest();

        List<AsyncApexJob> asyncApexJobs = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE];
        Assert.areEqual(1, asyncApexJobs.size(), 'Expected BatchTrailheadEntityUpdateSync to be scheduled after sync job finishes.');
        Assert.areEqual('Queued', asyncApexJobs[0].Status, 'Expected BatchTrailheadEntityUpdateSync to be scheduled after sync job finishes.');
    }

    @isTest
    private static void it_should_not_enqueue_batch_job_when_no_updates() {
        trailheadapp__Debug_Log__c syncFinishLog = new trailheadapp__Debug_Log__c(
            trailheadapp__Class__c = DebugLogTriggerHandler.SYNC_FINISHED_CLASS,
            trailheadapp__Method__c = DebugLogTriggerHandler.SYNC_FINISHED_METHOD,
            trailheadapp__Message__c = DebugLogTriggerHandler.SYNC_FINISHED_MESSAGE,
            trailheadapp__Severity__c = DebugLogTriggerHandler.SYNC_FINISHED_SEVERITY,
            trailheadapp__DateTime__c = DateTime.now(),
            trailheadapp__Transaction__c = 'current transaction'
        );

        Test.startTest();
        insert syncFinishLog;
        Test.stopTest();

        Assert.areEqual(
            0, 
            [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE].size(),
            'Did not expect BatchTrailheadEntityUpdateSync to be scheduled when there are no Trailhead Entity Update records.'
        );
    }

    @isTest
    private static void it_should_not_enqueue_batch_job_more_than_once_per_transaction() {
        DebugLogTS debugLogGenerator = new DebugLogTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 30},
            new List<TestSupport.TestDataField>{
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Class__c, DebugLogTriggerHandler.SYNC_FINISHED_CLASS),
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Method__c, DebugLogTriggerHandler.SYNC_FINISHED_METHOD),
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Message__c, DebugLogTriggerHandler.SYNC_FINISHED_MESSAGE),
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Severity__c, DebugLogTriggerHandler.SYNC_FINISHED_SEVERITY)
            }
        );

        TrailheadEntityUpdate__c trailheadEntityUpdate = new TrailheadEntityUpdate__c(
            APIName__c = 'Test',
            EntityType__c = 'trailheadapp__Trail__c',
            Products__c = 'New products.',
            UpdatedFields__c = 'Products__c'
        );
        insert trailheadEntityUpdate;

        Test.startTest();
        insert debugLogGenerator.generate();
        Test.stopTest();

        List<AsyncApexJob> asyncApexJobs = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE];
        Assert.areEqual(1, asyncApexJobs.size(), 'Expected BatchTrailheadEntityUpdateSync to be scheduled once in transaction after sync job finishes.');
        Assert.areEqual('Queued', asyncApexJobs[0].Status, 'Expected BatchTrailheadEntityUpdateSync to be scheduled after sync job finishes.');
    }
}