/**
 * Trigger handler for the StorageEvent__e platform event
 * @author Ben Learn
 * @since 07-17-2024
 * @group Core
 */
public without sharing class StorageEventTriggerHandler extends TriggerHandler {
    private static final Set<String> COMPARISON_OPERATORS = new Set<String>{
        '=',
        '!=',
        '<',
        '<=',
        '>',
        '>=',
        'LIKE',
        'NOT LIKE'
    };

    @TestVisible
    private static final String NOT_ALL_POPULATED_ERROR_MESSAGE = 'If a condition is provided, ConditionField__c, ConditionOperator__c, and ConditionValue__c must all be populated.';
    
    @TestVisible
    private static final String UNSUPPORTED_OPERATOR_ERROR_MESSAGE = 'ConditionOperator__c must be one of the following: =, !=, <, <=, >, >=, LIKE, NOT LIKE';

    /**
     * Constructor for trigger handler
     */    
    public StorageEventTriggerHandler() {
        super();
    }

    /**
     * After insert logic
     * @param newRecordsMap Map of IDs to newly inserted StorageEvent__e events
     */    
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        List<StorageEvent__e> storageEvents = (List<StorageEvent__e>) newRecordsMap.values();
        for(StorageEvent__e ev : storageEvents) {
            String condition = validateCondition(ev.ConditionField__c, ev.ConditionOperator__c, ev.ConditionValue__c);
            switch on ev.Action__c {
                when 'delete' {
                    deleteRecords(ev.Object__c, condition);
                }
            }
        }
    }

    private static void deleteRecords(String objectName, String condition) {
        String query = condition == null ? String.format('SELECT Id FROM {0}', new List<Object>{String.escapeSingleQuotes(objectName)}) : String.format(
            'SELECT Id FROM {0} WHERE {1}', new List<Object>{String.escapeSingleQuotes(objectName), condition}
        );
        List<sObject> recordsToDelete = Database.query(query);
        List<Database.DeleteResult> deleteResults = Database.delete(recordsToDelete, false, AccessLevel.SYSTEM_MODE);
        Boolean hasErrors = DMLUtils.logErrors(deleteResults, 'StorageEventTriggerHandler');
        if(!hasErrors) {
            List<Database.EmptyRecycleBinResult> emptyRecycleBinResults = Database.emptyRecycleBin(recordsToDelete);
            DMLUtils.logErrors(emptyRecycleBinResults, 'StorageEventTriggerHandler');
        }
    }

    /**
     * Validates/sanitizes values given for ConditionField__c, ConditionOperator__c, and ConditionValue__c before running query to get records to perform specified action on
     * @param conditionField Optional field used to filter records of specified object to determine whether they undergo the specified action
     * @param conditionOperator Optional operator used to filter records of specified object to determine whether they undergo the specified action
     * @param conditionValue Optional value used to filter records of specified object to determine whether they undergo the specified action
     * @return  `String`
     * @exception throws StorageEventException if one or two (but not all three) of ConditionField__c, ConditionOperator__c, and ConditionValue__c are populated or if an unsupported
     * operator is given for ConditionOperator__c
     */
    @testVisible 
    private static String validateCondition(String conditionField, String conditionOperator, String conditionValue) {
        if(conditionField == null && conditionOperator == null && conditionValue == null) {
            return null;
        } else if(conditionField == null || conditionOperator == null || conditionValue == null) {
            throw new StorageEventException(NOT_ALL_POPULATED_ERROR_MESSAGE);
        } else if(!COMPARISON_OPERATORS.contains(conditionOperator)) {
            throw new StorageEventException(UNSUPPORTED_OPERATOR_ERROR_MESSAGE);
        }

        return String.format(
            '{0} {1} {2}', 
            new List<Object>{String.escapeSingleQuotes(conditionField), String.escapeSingleQuotes(conditionOperator), String.escapeSingleQuotes(conditionValue)}
        );
    }

    @TestVisible
    private class StorageEventException extends Exception{}
}