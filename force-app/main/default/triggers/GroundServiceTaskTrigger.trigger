trigger GroundServiceTaskTrigger on Ground_Service_Task__c (after update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        GroundServiceTaskService.afterUpdate(
            Trigger.new,
            Trigger.oldMap
        );
    }

}