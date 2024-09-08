# Task 1: Azure DevOps Pipeline Creation for .NET Core Application

## Overview

This document outlines the steps  for Task 1: Azure DevOps Pipeline Creation includes set up a CI/CD pipeline in Azure DevOps for a .NET Core application. The pipeline automates code checkout, building, testing, static code analysis, deployment, and monitoring.

## Prerequisites

1. **Azure Subscription**: for deploying resources.
2. **SonarQube Server**: Set up SonarQube for static code analysis.
3. **Application Insights**: Set up for monitoring application performance.

## Pipeline Configuration

The pipeline is defined using a YAML file, which includes the following key elements:

### Trigger

- **Branches**: The pipeline is triggered on changes to the `master` branch.

### Pool

- **VM Image**: Uses `ubuntu-latest` for the build agent.

### Variables

- **Build Configuration**: Set to `Release`.
- **.NET Core Version**: Version `8.0.x`.
- **SonarQube Connection**: Name of the SonarQube service connection.
- **Azure Subscription**: Azure subscription name.
- **Web App Name**: The name of your Azure App Service.

### Steps

1. **Checkout the Code**:
   - Uses the `Checkout@1` task to retrieve the source code.

2. **Install .NET SDK**:
   - Uses the `UseDotNet@2` task to install the specified .NET SDK.

3. **Restore NuGet Packages**:
   - Runs a script to restore dependencies using `dotnet restore`.

4. **Build the Application**:
   - Builds the application using `dotnet build`.

5. **Run Unit Tests**:
   - Executes unit tests with `dotnet test`.

6. **SonarQube Analysis**:
   - Prepares for SonarQube analysis, builds the project again for analysis, and publishes results.

7. **Publish Artifact**:
   - Publishes build artifacts for later deployment.

8. **Deploy to Azure App Service**:
   - Uses the `AzureWebApp@1` task to deploy the application to Azure.

9. **Application Insights Integration**:
   - Configures Application Insights using the instrumentation key.

## Steps to Create the Pipeline

### Step 1: Create the Azure DevOps Pipeline

1. **Access the Pipelines Section**:
   - Click on **Pipelines** in the left sidebar.
2. **New Pipeline**:
   - Click on **New Pipeline** to start the setup process.
3. **Select Repository Source**:
   - Choose **Azure Repos Git**
   - Select DevOps.Backend repository from the list.

### Step 4: Configure the Pipeline

1. **Pipeline Configuration**:
   - Create a new file named `azure-pipelines.yaml` in the repository
2. **Define Pipeline Triggers**:
   - Ensure your YAML has the trigger set for the `master` branch.

### Step 5: Set Up Service Connections

1. **SonarQube Service Connection**:
   - In Azure DevOps, navigate to **Project Settings** > **Service Connections** and create a connection for SonarQube.
2. **Azure Subscription**:
   - Create a service connection for your Azure subscription.

### Step 6: Run the Pipeline

1. **Trigger the Pipeline**:
   - Go to the **Pipelines** section in Azure DevOps.
   - Select your pipeline and click on **Run Pipeline**.
2. **Monitor Execution**:
   - Watch the pipeline run in real-time, checking for any errors or warnings.

### Step 7: Verify Deployment and Monitoring

1. **Access Your App**:
   - Once deployment is complete, navigate to the URL of your Azure App Service.
   - Verify that the application is running as expected.
2. **Check Application Insights**:
   - Go to the Application Insights resource in the Azure portal.
   - Review telemetry data to ensure that application performance and errors are being tracked.

--------------------------------

## Storing Sensitive Information with Environment Variables

In Azure DevOps, you can securely manage sensitive information using environment variables. Here's how:

### 1. Create Variable Groups

- Navigate to **Pipelines > Library** and click **+ Variable group**.
- Add variables (e.g., `azureSubscription`, `webAppName`, `sonarQubeConnection`) and mark them as secret if needed.

### 2. Reference Variables in Pipeline

Use the syntax `$(VariableName)` in  YAML file:

```yaml
variables:
  azureSubscription: 'YourAzureSubscription'
  webAppName: 'YourWebAppName'
```

------------------------------------  

## Using SonarQube

### Setting Up SonarQube on My Machine

To run SonarQube locally, i followed these steps:

1. **Prerequisites**:
   - Ensure you have Java (JDK 11 or later) installed on your machine

2. **install SonarQube**:

3. **Start SonarQube**:
   - SonarQube will start, and you can access it by navigating to `http://localhost:9000` in my web browser.

5. **Log In**:
   - The default credentials are:
     - Username: `admin`
     - Password: `admin`

6. **Create a Project**:
   - create a new project in SonarQube to analyze the application.
   - Generate a token for the project, which will be used in the Azure DevOps pipeline for authentication.

### Integrating SonarQube with Azure DevOps

1. **Service Connection**:
   - In Azure DevOps, navigate to **Project Settings** > **Service Connections**.
   - Click on **New Service Connection** and select **SonarQube**.
   - Enter the required details:
     - **SonarQube Server URL**: `http://<your-sonarqube-url>:9000`
     - **Authentication Token**: Use the token generated in the previous step.
   - Give the service connection a name (e.g., `SonarQubeServiceConnection`) and save it.

2. **Using SonarQube in Your Pipeline**:
   - With the service connection set up, you can now use the SonarQube tasks in your Azure DevOps pipeline YAML file as shown in the previous sections.

### Note on Local SonarQube URL

When running SonarQube locally, the local URL (e.g., `http://localhost:9000`) will not work in Azure DevOps due to network restrictions. Azure DevOps cannot access services hosted on your local machine directly.

### Suggested Solutions

To integrate SonarQube into your Azure DevOps pipeline, consider one of the following solutions:

1. **Public Deployment**:
   - Deploy SonarQube on a cloud server or virtual machine with a public IP address. This allows Azure DevOps to access SonarQube directly. Make sure to secure it with proper authentication.

2. **Reverse Proxy**:
   - Set up a reverse proxy (using Nginx or Apache) that routes traffic to your local SonarQube instance. This proxy should be hosted on a publicly accessible server.

3. **VPN Connection**:
   - Establish a VPN connection between Azure DevOps and your local network hosting SonarQube. This setup allows secure access to the local SonarQube server.

4. **Self-Hosted Agent**:
   - Use a self-hosted Azure DevOps agent that runs on the same network as your local SonarQube server. This way, the agent can access SonarQube without any network issues.
