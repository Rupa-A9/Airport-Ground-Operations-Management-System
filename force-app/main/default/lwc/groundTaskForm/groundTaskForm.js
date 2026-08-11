import { LightningElement } from 'lwc';

import createGroundTask
    from '@salesforce/apex/GroundTaskController.createGroundTask';

import { ShowToastEvent }
    from 'lightning/platformShowToastEvent';

import { RefreshEvent }
    from 'lightning/refresh';


export default class GroundTaskForm extends LightningElement {

    // ============================================
    // Form Values
    // ============================================

    flightNumber = '';

    taskType = '';

    priority = '';

    status = 'In Progress';


    // ============================================
    // Component State
    // ============================================

    isSaving = false;


    // ============================================
    // Task Type Options
    // ============================================

    get taskTypeOptions() {

        return [
            {
                label: 'Refueling',
                value: 'Refueling'
            },
            {
                label: 'Cleaning',
                value: 'Cleaning'
            },
            {
                label: 'Baggage',
                value: 'Baggage'
            },
            {
                label: 'Catering',
                value: 'Catering'
            },
            {
                label: 'Maintenance',
                value: 'Maintenance'
            }
        ];
    }


    // ============================================
    // Priority Options
    // ============================================

    get priorityOptions() {

        return [
            {
                label: 'Low',
                value: 'Low'
            },
            {
                label: 'Medium',
                value: 'Medium'
            },
            {
                label: 'High',
                value: 'High'
            }
        ];
    }


    // ============================================
    // Status Options
    // ============================================

    get statusOptions() {

        return [
            {
                label: 'In Progress',
                value: 'In Progress'
            },
            {
                label: 'Completed',
                value: 'Completed'
            }
        ];
    }


    // ============================================
    // Handle Input Changes
    // ============================================

    handleChange(event) {

        const fieldName = event.target.name;

        const fieldValue =
            event.detail?.value ?? event.target.value;

        this[fieldName] = fieldValue;
    }


    // ============================================
    // Submit Form
    // ============================================

    async handleSubmit() {

        // Validate form
        if (!this.validateForm()) {

            return;
        }


        this.isSaving = true;


        try {

            // Call Apex
            await createGroundTask({

                flightNumber: this.flightNumber,

                taskType: this.taskType,

                priority: this.priority,

                status: this.status

            });


            // Success message
            this.showToast(
                'Success',
                'Ground service task created successfully.',
                'success'
            );


            // Clear form
            this.handleClear();


            // Notify the Lightning page that data changed
            this.dispatchEvent(
                new RefreshEvent()
            );

        }

        catch (error) {

            this.showToast(
                'Error',
                this.getErrorMessage(error),
                'error'
            );

        }

        finally {

            this.isSaving = false;
        }
    }


    // ============================================
    // Form Validation
    // ============================================

    validateForm() {

        const inputs =
            this.template.querySelectorAll(
                'lightning-input, lightning-combobox'
            );


        let isValid = true;


        inputs.forEach(input => {

            if (!input.reportValidity()) {

                isValid = false;
            }

        });


        return isValid;
    }


    // ============================================
    // Clear Form
    // ============================================

    handleClear() {

        this.flightNumber = '';

        this.taskType = '';

        this.priority = '';

        this.status = 'In Progress';


        const inputs =
            this.template.querySelectorAll(
                'lightning-input, lightning-combobox'
            );


        inputs.forEach(input => {

            input.value =
                input.name === 'status'
                    ? 'In Progress'
                    : '';
        });
    }


    // ============================================
    // Toast
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
    // Error Message
    // ============================================

    getErrorMessage(error) {

        if (error?.body?.message) {

            return error.body.message;
        }


        if (error?.message) {

            return error.message;
        }


        return 'Unable to create the ground service task.';
    }
}