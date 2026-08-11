
import { LightningElement, api } from 'lwc';

export default class GroundTaskCard extends LightningElement {

    // Data received from parent
    @api task;

    @api processingTaskId;


    // Check whether this task is currently being processed
    get isSubmitting() {

        return this.processingTaskId === this.task?.Id;
    }


    // Check whether task can be completed
    get isReady() {

        return this.task &&
               this.task.Task_Status__c !== 'Completed' &&
               !this.isSubmitting;
    }


    // Check whether task is already completed
    get isCompleted() {

        return this.task &&
               this.task.Task_Status__c === 'Completed';
    }


    // View Details
    handleViewDetails() {

        this.dispatchEvent(
            new CustomEvent('viewdetails', {
                detail: {
                    taskId: this.task.Id
                }
            })
        );
    }


    // Complete Task
    handleCompleteTask() {

        // Prevent repeated clicks
        if (
            this.isSubmitting ||
            this.isCompleted
        ) {
            return;
        }


        // Send event to parent
        this.dispatchEvent(
            new CustomEvent('completetask', {
                detail: {
                    taskId: this.task.Id
                }
            })
        );
    }

}
