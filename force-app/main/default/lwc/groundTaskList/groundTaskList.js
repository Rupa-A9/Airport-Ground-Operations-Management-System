import { LightningElement, wire } from 'lwc';

import getGroundTasks
    from '@salesforce/apex/GroundTaskController.getGroundTasks';

import completeTask
    from '@salesforce/apex/GroundTaskController.completeTask';

import { refreshApex }
    from '@salesforce/apex';

import { ShowToastEvent }
    from 'lightning/platformShowToastEvent';


export default class GroundTaskList extends LightningElement {

    // ============================================
    // Component State
    // ============================================

    tasks = [];

    isLoading = true;

    errorMessage;

    processingTaskId;

    wiredTasksResult;


    // ============================================
    // Retrieve Tasks
    // ============================================

    @wire(getGroundTasks)
    wiredTasks(result) {

        this.wiredTasksResult = result;

        const { data, error } = result;

        if (data) {

            this.tasks = data;

            this.errorMessage = undefined;

            this.isLoading = false;

        } else if (error) {

            this.tasks = [];

            this.errorMessage =
                this.getErrorMessage(error);

            this.isLoading = false;
        }
    }


    // ============================================
    // Handle Complete Task
    // ============================================

    async handleCompleteTask(event) {

        const taskId = event.detail.taskId;

        this.processingTaskId = taskId;

        this.errorMessage = undefined;


        try {

            // Call Apex imperatively
            await completeTask({
                taskId: taskId
            });


            // Success message
            this.showToast(
                'Success',
                'Ground service task completed successfully.',
                'success'
            );


            // Refresh wired data
            await refreshApex(
                this.wiredTasksResult
            );


        } catch (error) {

            this.errorMessage =
                this.getErrorMessage(error);


            this.showToast(
                'Error',
                this.errorMessage,
                'error'
            );


        } finally {

            this.processingTaskId = undefined;
        }
    }


    // ============================================
    // Show Tasks
    // ============================================

    get showTasks() {

        return !this.isLoading &&
               !this.errorMessage &&
               this.tasks.length > 0;
    }


    // ============================================
    // Show Empty State
    // ============================================

    get showEmptyState() {

        return !this.isLoading &&
               !this.errorMessage &&
               this.tasks.length === 0;
    }


    // ============================================
    // Toast Message
    // ============================================

    showToast(title, message, variant) {

        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }


    // ============================================
    // Error Message
    // ============================================

    getErrorMessage(error) {

        if (error?.body?.message) {

            return error.body.message;
        }

        if (error?.message) {

            return error.message;
        }

        return 'Unable to process the request. Please try again.';
    }
}