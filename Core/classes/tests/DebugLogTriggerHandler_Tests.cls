@isTest
private class DebugLogTriggerHandler_Tests {
    private static final String ASYNC_JOB_TYPE = 'BatchApex';
    private static final String DELETE_BATCH_CLASS_NAME = 'BatchTrailheadEntityDeleteSync';
    private static final String UPDATE_BATCH_CLASS_NAME = 'BatchTrailheadEntityUpdateSync';
    
    private static final String BADGE_SYNC_CLASS = 'Badge';
    private static final String TRAIL_SYNC_CLASS = 'Trail';
    private static final String BADGE_SYNC_METHOD = 'upsertBadges';
    private static final String TRAIL_SYNC_METHOD = 'upsertTrails';
    private static final String BADGE_SYNC_MESSAGE = 'Upserted 2241 Badge records.';
    private static final String TRAIL_SYNC_MESSAGE = 'Upserted 408 Trail records.';
    private static final String SYNC_FINISHED_SEVERITY = 'INFO';

    private static List<trailheadapp__Debug_Log__c> generateSyncFinishedLogs() {
        return new List<trailheadapp__Debug_Log__c>{
            new trailheadapp__Debug_Log__c(
                trailheadapp__Class__c = BADGE_SYNC_CLASS,
                trailheadapp__Method__c = BADGE_SYNC_METHOD,
                trailheadapp__Message__c = BADGE_SYNC_MESSAGE,
                trailheadapp__Severity__c = SYNC_FINISHED_SEVERITY,
                trailheadapp__DateTime__c = DateTime.now(),
                trailheadapp__Transaction__c = 'current transaction'
            ),
            new trailheadapp__Debug_Log__c(
                trailheadapp__Class__c = TRAIL_SYNC_CLASS,
                trailheadapp__Method__c = TRAIL_SYNC_METHOD,
                trailheadapp__Message__c = TRAIL_SYNC_MESSAGE,
                trailheadapp__Severity__c = SYNC_FINISHED_SEVERITY,
                trailheadapp__DateTime__c = DateTime.now(),
                trailheadapp__Transaction__c = 'current transaction'
            )
        };
    }

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

        TrailheadEntityDelete__c trailheadEntityDelete = new TrailheadEntityDelete__c(
            APIName__c = 'Test',
            EntityType__c = 'trailheadapp__Badge__c'
        );
        insert trailheadEntityDelete;

        List<trailheadapp__Debug_Log__c> syncFinishedLogs = generateSyncFinishedLogs();

        Test.startTest();
        insert debugLogGenerator.generate();

        Assert.areEqual(
            0, 
            [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name IN (:UPDATE_BATCH_CLASS_NAME, :DELETE_BATCH_CLASS_NAME) AND JobType = :ASYNC_JOB_TYPE].size(), 
            'Did not expect BatchTrailheadEntityUpdateSync to be scheduled without sync job finishing first.'
        );

        insert syncFinishedLogs;
        Test.stopTest();

        List<AsyncApexJob> updateBatchJobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = :UPDATE_BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE];
        List<AsyncApexJob> deleteBatchJobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = :DELETE_BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE];
        Assert.areEqual(1, updateBatchJobs.size(), 'Expected BatchTrailheadEntityUpdateSync to be scheduled after sync job finishes.');
        Assert.areEqual('Queued', updateBatchJobs[0].Status, 'Expected BatchTrailheadEntityUpdateSync to be scheduled after sync job finishes.');
        Assert.areEqual(1, deleteBatchJobs.size(), 'Expected BatchTrailheadEntityDeleteSync to be scheduled after sync job finishes.');
        Assert.areEqual('Queued', deleteBatchJobs[0].Status, 'Expected BatchTrailheadEntityDeleteSync to be scheduled after sync job finishes.');
        
        System.abortJob(updateBatchJobs[0].Id);
        System.abortJob(deleteBatchJobs[0].Id);
    }

    @isTest
    private static void it_should_not_enqueue_batch_job_when_no_updates() {
        List<trailheadapp__Debug_Log__c> syncFinishedLogs = generateSyncFinishedLogs();
        Test.startTest();
        insert syncFinishedLogs;
        Test.stopTest();

        Assert.areEqual(
            0, 
            [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :UPDATE_BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE].size(),
            'Did not expect BatchTrailheadEntityUpdateSync to be scheduled when there are no Trailhead Entity Update records.'
        );
    }

    @isTest
    private static void it_should_not_enqueue_batch_job_when_no_deletes() {
        List<trailheadapp__Debug_Log__c> syncFinishedLogs = generateSyncFinishedLogs();
        Test.startTest();
        insert syncFinishedLogs;
        Test.stopTest();

        Assert.areEqual(
            0, 
            [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :DELETE_BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE].size(),
            'Did not expect BatchTrailheadEntityDeleteSync to be scheduled when there are no Trailhead Entity Delete records.'
        );
    }

    @isTest
    private static void it_should_not_enqueue_batch_job_more_than_once_per_transaction() {
        DebugLogTS debugLogGenerator = new DebugLogTS(
            new Map<String, Object>{
                'generateRecordIDs' => false,
                'generatorReturnValue' => 'all',
                'numberToGenerate' => 30
            },
            new List<TestSupport.TestDataField>{
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Class__c, BADGE_SYNC_CLASS),
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Method__c, BADGE_SYNC_METHOD),
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Message__c, BADGE_SYNC_MESSAGE),
                new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Severity__c, SYNC_FINISHED_SEVERITY)
            }
        );
        debugLogGenerator.generate();
        List<trailheadapp__Debug_Log__c> debugLogs = debugLogGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
            new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Class__c, TRAIL_SYNC_CLASS),
            new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Method__c, TRAIL_SYNC_METHOD),
            new TestSupport.TestDataField(trailheadapp__Debug_Log__c.trailheadapp__Message__c, TRAIL_SYNC_MESSAGE)
        }).generate();

        TrailheadEntityUpdate__c trailheadEntityUpdate = new TrailheadEntityUpdate__c(
            APIName__c = 'Test',
            EntityType__c = 'trailheadapp__Trail__c',
            Products__c = 'New products.',
            UpdatedFields__c = 'Products__c'
        );
        insert trailheadEntityUpdate;

        TrailheadEntityDelete__c trailheadEntityDelete = new TrailheadEntityDelete__c(
            APIName__c = 'Test',
            EntityType__c = 'trailheadapp__Badge__c'
        );
        insert trailheadEntityDelete;

        Test.startTest();
        insert debugLogs;
        Test.stopTest();

        List<AsyncApexJob> updateBatchJobs = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :UPDATE_BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE];
        Assert.areEqual(1, updateBatchJobs.size(), 'Expected BatchTrailheadEntityUpdateSync to be scheduled once in transaction after sync job finishes.');
        Assert.areEqual('Queued', updateBatchJobs[0].Status, 'Expected BatchTrailheadEntityUpdateSync to be scheduled after sync job finishes.');
        List<AsyncApexJob> deleteBatchJobs = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = :DELETE_BATCH_CLASS_NAME AND JobType = :ASYNC_JOB_TYPE];
        Assert.areEqual(1, deleteBatchJobs.size(), 'Expected BatchTrailheadEntityDeleteSync to be scheduled once in transaction after sync job finishes.');
        Assert.areEqual('Queued', deleteBatchJobs[0].Status, 'Expected BatchTrailheadEntityDeleteSync to be scheduled after sync job finishes.');

        System.abortJob(updateBatchJobs[0].Id);
        System.abortJob(deleteBatchJobs[0].Id);
    }

    @isTest
    private static void it_should_publish_storage_events() {
        List<trailheadapp__Debug_Log__c> syncFinishedLogs = generateSyncFinishedLogs();
        syncFinishedLogs.add(new trailheadapp__Debug_Log__c(
            trailheadapp__Class__c = 'TrailheadSync',
            trailheadapp__Method__c = 'start',
            trailheadapp__Message__c = 'Processing 84 Trailmix records.',
            trailheadapp__Severity__c = SYNC_FINISHED_SEVERITY,
            trailheadapp__DateTime__c = DateTime.now(),
            trailheadapp__Transaction__c = 'current transaction'
        ));

        Test.startTest();
        insert syncFinishedLogs;
        Assert.areEqual(syncFinishedLogs.size() * 2, Limits.getDmlRows(), 'Expected one DML row for each Debug Log record and one for each published Storage Event.');
        Assert.areEqual(2, Limits.getDmlStatements(), 'Expected one DML statement for insert of Debug Logs and a second for publish of Storage Events.');
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [SELECT Id FROM LogEntry__c WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'];
        Assert.areEqual(0, loggedErrors.size(), 'Expected Storage Events to publish successfully.');
    }
}