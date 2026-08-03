trigger FlightTrigger on Flight__c (
    before insert,
    before update
) {
    FlightTriggerHandler.preventDuplicateGateAssignment(Trigger.new, Trigger.oldMap);
}