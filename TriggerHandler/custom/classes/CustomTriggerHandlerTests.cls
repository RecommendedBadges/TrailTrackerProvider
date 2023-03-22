@isTest
private class CustomTriggerHandlerTests {
    private class TestTriggerHandler extends TriggerHandler {
        public TriggerOperation Method { get; private set;}
        
        @testVisible
        protected override void beforeInsert(List<sObject> newRecords) {
            this.Method = TriggerOperation.BEFORE_INSERT;
            super.beforeInsert(newRecords);
        }
        
        @testVisible
        protected override void beforeUpdate(Map<Id, SObject> updatedRecordsMap, Map<Id, SObject> oldRecordsMap) {
            this.Method = TriggerOperation.BEFORE_UPDATE;
            super.beforeUpdate(updatedRecordsMap, oldRecordsMap);
        }

        @testVisible
        protected override void beforeDelete(Map<Id, sObject> deletedRecordsMap) {
            this.Method = TriggerOperation.BEFORE_DELETE;
            super.beforeDelete(deletedRecordsMap);
        }

        @testVisible
        protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
            this.Method = TriggerOperation.AFTER_INSERT;
            super.afterInsert(newRecordsMap);
        }

        @testVisible
        protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<id, sObject> oldRecordsMap) {
            this.Method = TriggerOperation.AFTER_UPDATE;
            super.afterUpdate(updatedRecordsMap, oldRecordsMap);
        }

        @testvisible
        protected override void afterDelete(Map<Id, sObject> deletedRecordsMap) {
            this.Method = TriggerOperation.AFTER_DELETE;
            super.afterDelete(deletedRecordsMap);
        }

        @testVisible
        protected override void afterUndelete(Map<Id, sObject> undeletedRecordsMap) {
            this.Method = TriggerOperation.AFTER_UNDELETE;
            super.afterUndelete(undeletedRecordsMap);
        }
    }

    @isTest
    private static void itShouldPerformBeforeInsert() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.BEFORE_INSERT;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.BEFORE_INSERT, testTriggerHandler.Method);
    }

    @isTest
    private static void itShouldPerformBeforeUpdate() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.BEFORE_UPDATE;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.BEFORE_UPDATE, testTriggerHandler.Method);
    }

    @isTest
    private static void itShouldPerformBeforeDelete() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.BEFORE_DELETE;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.BEFORE_DELETE, testTriggerHandler.Method);
    }

    @isTest
    private static void itShouldPerformAfterInsert() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.AFTER_INSERT;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.AFTER_INSERT, testTriggerHandler.Method);
    }

    @isTest
    private static void itShouldPerformAfterUpdate() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.AFTER_UPDATE;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.AFTER_UPDATE, testTriggerHandler.Method);
    }
    
    @isTest
    private static void itShouldPerformAfterDelete() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.AFTER_DELETE;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.AFTER_DELETE, testTriggerHandler.Method);
    }
    
    @isTest
    private static void itShouldPerformAfterUndelete() {
        TestTriggerHandler testTriggerHandler = new TestTriggerHandler();
        TriggerHandler.triggerContext = TriggerOperation.AFTER_UNDELETE;
        testTriggerHandler.execute();
        Assert.areEqual(TriggerOperation.AFTER_UNDELETE, testTriggerHandler.Method);
    }
}