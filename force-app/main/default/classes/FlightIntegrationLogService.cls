public with sharing class FlightIntegrationLogService {

    public static Flight_Integration_Log__c createLog(
        String flightNumber
    ) {
        Flight_Integration_Log__c log =
            new Flight_Integration_Log__c();

        log.Flight_Number__c = flightNumber;
        log.Status__c = 'Pending';
        log.Attempt_Count__c = 1;
        log.Last_Attempt__c = System.now();

        insert log;

        return log;
    }

    public static void markSuccess(
        Flight_Integration_Log__c log
    ) {
        log.Status__c = 'Success';
        log.Error_Message__c = null;
        log.Last_Attempt__c = System.now();

        update log;
    }

    public static void markFailure(
        Flight_Integration_Log__c log,
        String errorMessage
    ) {
        log.Status__c = 'Failed';
        log.Error_Message__c = errorMessage;
        log.Last_Attempt__c = System.now();

        update log;
    }
}