import {
    LightningElement,
    wire
} from 'lwc';

import getGroundTasks
    from '@salesforce/apex/GroundTaskController.getGroundTasks';

import completeTask
    from '@salesforce/apex/GroundTaskController.completeTask';

import { refreshApex }
    from '@salesforce/apex';

import { ShowToastEvent }
    from 'lightning/platformShowToastEvent';

import {
    registerRefreshHandler,
    unregisterRefreshHandler
} from 'lightning/refresh';


export default class GroundTaskList extends LightningElement {

    // ============================================
    // Component State
    // ============================================

    tasks = [];

    isLoading = true;

    errorMessage;

    processingTaskId;

    wiredTasksResult;

    selectedTask;

    refreshHandlerId;


    // ============================================
    // Component Connected
    // ============================================

    connectedCallback() {

        this.refreshHandlerId =
            registerRefreshHandler(
                this,
                this.handleRefresh.bind(this)
            );
    }


    // ============================================
    // Component Disconnected
    // ============================================

    disconnectedCallback() {

        if (this.refreshHandlerId) {

            unregisterRefreshHandler(
                this.refreshHandlerId
            );
        }
    }


    // ============================================
    // Retrieve Ground Tasks
    // ============================================

    @wire(getGroundTasks)
    wiredTasks(result) {

        this.wiredTasksResult = result;

        const { data, error } = result;


        if (data) {

            this.tasks = data;

            this.errorMessage = undefined;

            this.isLoading = false;

        }

        else if (error) {

            this.tasks = [];

            this.errorMessage =
                this.getErrorMessage(error);

            this.isLoading = false;
        }
    }


    // ============================================
    // Handle Lightning Refresh
    // ============================================

    async handleRefresh() {

        if (this.wiredTasksResult) {

            await refreshApex(
                this.wiredTasksResult
            );
        }
    }


    // ============================================
    // View Task Details
    // ============================================

    handleViewDetails(event) {

        const taskId =
            event.detail.taskId;

        this.selectedTask =
            this.tasks.find(
                task => task.Id === taskId
            );
    }


    // ============================================
    // Complete Task
    // ============================================

    async handleCompleteTask(event) {

        const taskId =
            event.detail.taskId;

        this.processingTaskId =
            taskId;

        this.errorMessage = undefined;


        try {

            // Call Apex
            await completeTask({
                taskId: taskId
            });


            // Show success message
            this.showToast(
                'Success',
                'Ground service task completed successfully.',
                'success'
            );


            // Refresh task data
            await refreshApex(
                this.wiredTasksResult
            );

        }

        catch (error) {

            this.errorMessage =
                this.getErrorMessage(error);


            this.showToast(
                'Error',
                this.errorMessage,
                'error'
            );

        }

        finally {

            this.processingTaskId =
                undefined;
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
    // Show Toast
    // ============================================

    showToast(
        title,
        message,
        variant
    ) {

        this.dispatchEvent(
            new ShowToastEvent({

                title: title,

                message: message,

                variant: variant
            })
        );
    }


    // ============================================
    // Get Error Message
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