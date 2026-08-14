# Chapter 12 – From Developer Org to Production

## Objective

Established a structured Salesforce development and deployment workflow using Salesforce CLI, VS Code, Git, and GitHub.

## Tools Used

- Salesforce
- VS Code
- Salesforce CLI
- Git
- GitHub

## Salesforce Development

- Connected the Salesforce Developer Org using Salesforce CLI.
- Used the Salesforce DX project structure.
- Managed metadata under `force-app/main/default/`.
- Retrieved and deployed Salesforce metadata.
- Verified the deployed functionality in Salesforce.

## Git & GitHub Workflow

- Used Git for version control.
- Created and worked with feature branches.
- Committed changes with meaningful commit messages.
- Pushed changes to GitHub.
- Created a Pull Request.
- Merged the completed changes into the `main` branch.

## Deployment Workflow

```text
Develop → Validate → Commit → Push → Pull Request
→ Review & Merge → Deploy → Test → Verify
```

## Testing

Apex test classes were executed to validate the implemented functionality and ensure the deployment was working correctly.

## API Integration

Implemented the `FlightOperationsApiService` Apex class for external Flight Operations API integration.

The integration uses the Named Credential:

`Flight_Operations_API`

The service retrieves flight information including:

- Flight Number
- Arrival
- Departure
- Terminal
- Gate
- Flight Status

## Key Learning Outcomes

- Salesforce CLI and Org Authentication
- Salesforce DX Project Structure
- Metadata Retrieval and Deployment
- Git and GitHub Version Control
- Feature Branches and Pull Requests
- Apex Testing
- Deployment Verification
- Named Credentials
- External API Integration
