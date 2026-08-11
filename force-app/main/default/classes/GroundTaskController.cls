
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


    // ============================================================
    // Create Ground Service Task
    // ============================================================
    @AuraEnabled
    public static Id createGroundTask(
        String flightNumber,
        String taskType,
        String priority,
        String status
    ) {

        if (String.isBlank(flightNumber)) {

            throw new AuraHandledException(
                'Flight Number is required.'
            );
        }


        if (String.isBlank(taskType)) {

            throw new AuraHandledException(
                'Task Type is required.'
            );
        }


        // Find the Flight
        List<Flight__c> flights = [
            SELECT Id
            FROM Flight__c
            WHERE Flight_Number__c = :flightNumber
            LIMIT 1
        ];


        if (flights.isEmpty()) {

            throw new AuraHandledException(
                'Flight ' + flightNumber + ' was not found.'
            );
        }


        // Create Ground Service Task
        Ground_Service_Task__c task =
            new Ground_Service_Task__c();

        task.Flight__c =
            flights[0].Id;

        task.Task_Type__c =
            taskType;

        task.Priority__c =
            priority;

        task.Task_Status__c =
            status;


        // Save record
        insert task;


        return task.Id;
    }
}
