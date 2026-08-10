# Sprint 09 – Interactive Lightning Web Components
## Airport Ground Operations Management System

## 1. Business Problem

Airport ground operations require staff to monitor and complete ground service tasks such as cleaning, refueling, and baggage handling.

The goal of this sprint was to build an interactive Lightning Web Component that allows airport ground staff to:

- View ground service tasks
- View task details
- Complete pending tasks
- See loading, success, empty, and error states
- Prevent repeated task-completion actions
- Refresh the interface after a task is completed

---

## 2. Component Architecture

The LWC was divided into parent and child components.

```text
groundTaskList
      |
      | passes task data
      ↓
groundTaskCard
      |
      | user clicks Complete Task
      ↓
Custom Event
      |
      ↓
groundTaskList
      |
      | Imperative Apex
      ↓
GroundTaskController
      |
      ↓
GroundServiceTaskService
      |
      ↓
Salesforce Database