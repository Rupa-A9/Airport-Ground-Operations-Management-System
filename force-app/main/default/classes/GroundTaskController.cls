public with sharing class GroundTaskController {

    // ============================================================
    // Get Ground Service Tasks
    // ============================================================
    @AuraEnabled(cacheable=true)
    public static List<Ground_Service_Task__c> getGroundTasks() {

        return [
            SELECT Id,
                   Name,
                   Task_Type__c,
                   Task_Status__c,
                   Priority__c,
                   Assigned_Crew__c,
                   Flight__c,
                   Flight__r.Flight_Number__c
            FROM Ground_Service_Task__c
            ORDER BY CreatedDate DESC
        ];
    }


    // ============================================================
    // Complete Ground Service Task
    // ============================================================
    @AuraEnabled
    public static void completeTask(Id taskId) {

        if (taskId == null) {
            throw new AuraHandledException(
                'Task Id is required.'
            );
        }

        try {

            GroundServiceTaskService.completeTask(taskId);

        } catch (AuraHandledException e) {

            throw e;

        } catch (Exception e) {

            System.debug(
                LoggingLevel.ERROR,
                'COMPLETE TASK ERROR: ' + e.getMessage()
            );

            System.debug(
                LoggingLevel.ERROR,
                e.getStackTraceString()
            );

            throw new AuraHandledException(
                'Unable to complete the task. Please try again.'
            );
        }
    }
}