# Chapter 13 – Salesforce Security

## Sprint 13 – Security, Access Control & Sharing

### Project
**Airport Ground Operations Management System**

---

## 1. Security Setup

The Salesforce security model was configured to control user and record access.

Implemented:

- Roles and Role Hierarchy
- Organization-Wide Defaults (OWD)
- Sharing Rules
- Permission Set
- Test User

---

## 2. Roles

Created the following operational hierarchy:

```text
Airport Operations Manager
        ↓
Airport Operations Officer
        ↓
Ground Service Staff

```
This represents the operational structure of the airport system.

---

## 3. Organization-Wide Defaults

OWD was configured for the project objects.

The required objects were set to:

**Public Read/Write**

This provides the baseline record access required for the current project design.

---

## 4. Sharing Rules

**6 Sharing Rules** were created to provide additional record-level access where required.

---

## 5. Permission Set

Created Permission Set:

**Airport Operations Access**

This provides additional permissions required for airport operational activities.

---

## 6. Test User

A test user was created to verify the configured security and access model.

---

## 7. Security Concepts Applied

- Object-Level Security
- Field-Level Security
- Record-Level Security
- Organization-Wide Defaults
- Role Hierarchy
- Sharing Rules
- Permission Sets
- Least Privilege
- Apex Security
- LWC Security

---

## 8. Security Principle

The project follows a layered security approach:

```text
Profile
   +
Permission Set
   +
Object Permissions
   +
Field-Level Security
   +
OWD
   +
Role Hierarchy
   +
Sharing Rules
   =
Effective Access
```

---

## Learning Outcomes

After completing Chapter 13, I learned how Salesforce manages security and access using Profiles, Permission Sets, Roles, OWD, and Sharing Rules. I also understood the difference between object-level, field-level, and record-level security and the importance of least privilege and secure Apex and LWC design.

---

## Conclusion

In this chapter, I implemented the Salesforce security model for the **Airport Ground Operations Management System**. I configured the Role Hierarchy and OWD, created 6 Sharing Rules, created the **Airport Operations Access** Permission Set, and created a test user. These configurations provide structured access control for airport operations based on user responsibilities.
