public with sharing class FlightOperationsApiService {

    public static void syncFlight(String flightNumber) {

        String logStatus = 'Failed';
        String errorMessage = null;

        try {

            HttpRequest request = new HttpRequest();

            request.setEndpoint(
                'callout:Flight_Operations_API/flights/' + flightNumber
            );

            request.setMethod('GET');

            request.setHeader(
                'Content-Type',
                'application/json'
            );

            Http http = new Http();

            HttpResponse response = http.send(request);

            System.debug(
                'Response Status: ' + response.getStatusCode()
            );

            System.debug(
                'Response Body: ' + response.getBody()
            );

            // Check API response
            if (response.getStatusCode() != 200) {

                errorMessage =
                    'Flight API call failed. HTTP Status: ' +
                    response.getStatusCode();

                createIntegrationLog(
                    flightNumber,
                    logStatus,
                    errorMessage
                );

                return;
            }

            // Convert JSON response into Salesforce Map
            Map<String, Object> flightData =
                (Map<String, Object>) JSON.deserializeUntyped(
                    response.getBody()
                );

            // Read values from API response
            String apiFlightNumber =
                (String) flightData.get('flightNumber');

            String airline =
                (String) flightData.get('airline');

            String status =
                (String) flightData.get('status');

            String terminal =
                (String) flightData.get('terminal');

            String originAirport =
                (String) flightData.get('originAirport');

            String destinationAirport =
                (String) flightData.get('destinationAirport');

            Integer passengerCount =
                (Integer) flightData.get('passengerCount');

            String scheduledArrival =
                (String) flightData.get('scheduledArrival');

            String scheduledDeparture =
                (String) flightData.get('scheduledDeparture');

            // Convert API DateTime values
            DateTime arrivalTime;
            DateTime departureTime;

            if (!String.isBlank(scheduledArrival)) {

                arrivalTime = DateTime.valueOf(
                    scheduledArrival.replace('T', ' ')
                );
            }

            if (!String.isBlank(scheduledDeparture)) {

                departureTime = DateTime.valueOf(
                    scheduledDeparture.replace('T', ' ')
                );
            }

            // Find existing Salesforce Flight record
            List<Flight__c> flights = [
                SELECT Id,
                       Flight_Number__c,
                       Airline__c,
                       Status__c,
                       Terminal__c,
                       Origin_Airport__c,
                       Destination_Airport__c,
                       Passenger_Count__c,
                       Delay_Reason__c,
                       Scheduled_Arrival__c,
                       Scheduled_Departure__c
                FROM Flight__c
                WHERE Flight_Number__c = :apiFlightNumber
                LIMIT 1
            ];

            // Flight does not exist
            if (flights.isEmpty()) {

                errorMessage =
                    'No Salesforce Flight record found for: ' +
                    apiFlightNumber;

                createIntegrationLog(
                    flightNumber,
                    logStatus,
                    errorMessage
                );

                return;
            }

            Flight__c flight = flights[0];

            // Update Salesforce fields
            flight.Airline__c = airline;
            flight.Status__c = status;
            flight.Terminal__c = terminal;
            flight.Origin_Airport__c = originAirport;
            flight.Destination_Airport__c = destinationAirport;
            flight.Passenger_Count__c = passengerCount;
            flight.Scheduled_Arrival__c = arrivalTime;
            flight.Scheduled_Departure__c = departureTime;

            // Handle validation rule
            if (
                status == 'Delayed' &&
                String.isBlank(flight.Delay_Reason__c)
            ) {

                flight.Delay_Reason__c =
                    'Delay information received from Flight Operations System';
            }

            // Save updated Flight record
            update flight;

            // Mark synchronization as successful
            logStatus = 'Success';

            createIntegrationLog(
                flightNumber,
                logStatus,
                null
            );

            System.debug(
                'Flight successfully synchronized: ' +
                flight.Flight_Number__c
            );

        } catch (Exception e) {

            errorMessage = e.getMessage();

            System.debug(
                'Flight synchronization failed: ' +
                errorMessage
            );

            createIntegrationLog(
                flightNumber,
                'Failed',
                errorMessage
            );
        }
    }

    private static void createIntegrationLog(
        String flightNumber,
        String status,
        String errorMessage
    ) {

        Flight_Integration_Log__c log =
            new Flight_Integration_Log__c();

        log.Flight_Number__c = flightNumber;
        log.Status__c = status;
        log.Attempt_Count__c = 1;
        log.Last_Attempt__c = System.now();

        if (!String.isBlank(errorMessage)) {
            log.Error_Message__c = errorMessage;
        }

        insert log;
    }
}