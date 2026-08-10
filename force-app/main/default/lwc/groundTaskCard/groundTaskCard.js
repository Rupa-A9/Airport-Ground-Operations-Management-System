import { LightningElement, api } from 'lwc';


export default class GroundTaskCard extends LightningElement {

    // ============================================
    // Data received from Parent
    // ============================================

    @api task;

    @api processingTaskId;


    // ============================================
    // Processing State
    // ============================================

    get isSubmitting() {

        return this.processingTaskId === this.task?.Id;
    }


    // ============================================
    // Ready State
    // ============================================

    get isReady() {

        return this.task &&
               this.task.Task_Status__c !== 'Completed' &&
               !this.isSubmitting;
    }


    // ============================================
    // Completed State
    // ============================================

    get isCompleted() {

        return this.task &&
               this.task.Task_Status__c === 'Completed';
    }


    // ============================================
    // User Clicks Complete
    // ============================================

    handleCompleteTask() {

        // Protect against repeated clicks

        if (
            this.isSubmitting ||
            this.isCompleted
        ) {

            return;
        }


        // Send event to parent

        this.dispatchEvent(

            new CustomEvent(
                'completetask',

                {
                    detail: {
                        taskId: this.task.Id
                    }
                }
            )

        );
    }
}