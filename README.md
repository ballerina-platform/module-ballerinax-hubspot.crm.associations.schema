# Ballerina HubSpot CRM Associations schema connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.associations.schema.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.associations.schema)

## Overview

[HubSpot](https://www.hubspot.com/) is an AI-powered customer relationship management (CRM) platform.

The `ballerinax/module-ballerinax-hubspot.crm.associations.schema` connector offers APIs to connect and interact with the [Hubspot Associations Schema API](https://developers.hubspot.com/docs/reference/api/crm/associations/associations-schema) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api).

## Setup guide

You need a HubSpot developer account and an associated app with API access to use the HubSpot Associations schema connector. If you don’t have one, register for a HubSpot developer account first.

### Step 1: Login to a HubSpot developer account

If you don't have a HubSpot Developer Account, you can sign up for a free account [here](https://developers.hubspot.com/get-started)

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

### Step 2: Create a developer test account (optional)

Within app developer accounts, you can create a [developer test account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account to test apps and integrations without affecting any real HubSpot data.

> **Note:** These accounts are only for development and testing purposes. In production, you should not use developer test accounts.

1. Go to the Test accounts section from the left sidebar.
    ![Test accounts section](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/test-account.png)

2. Click the `Create developer test account` button in the top right corner.
    ![Create developer test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/create-test-account.png)

3. In the pop-up window, provide a name for the test account and click the `Create` button.
    ![Create test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/create-account.png)
    You will see the newly created test account in the list of test accounts.
    ![Test account portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/test-account-portal.png)

### Step 3: Create a HubSpot app

1. Navigate to the `Apps` section in the left sidebar and click the `Create app` button in the top right corner.
    ![Create app](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/create-app.png)

2. Provide a public app name and description for your app.
    ![App name and description](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/app-name-desc.png)

### Step 4: Setup authentication

1. Move to the `Auth` tab.
    ![Configure authentication](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/config-auth.png)

2. Add the following scopes for your app using the `Add new scopes` button in the `Scopes` section.

- `crm.objects.contacts.read`
- `crm.objects.contacts.write`
- `crm.objects.companies.read`
- `crm.objects.companies.write`
- `crm.objects.deals.read`
- `crm.objects.deals.write`
- `crm.objects.line_items.read`
- `crm.objects.line_items.write`
- `crm.objects.custom.read`
- `crm.objects.custom.write`

    ![Add scopes](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/add-scopes.png)

3. Add the redirect URL for your app in the `Redirect URL` section. This is the URL where the user will be redirected after authentication. You can use `localhost` for testing purposes. Then click the `Create App` button.

    ![Redirect URL](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/redirect-url.png)

### Step 5: Get the client ID and client secret

Navigate to the `Auth` tab to see your app's `Client ID` and `Client Secret`. Make sure to save these values.

![Client ID and Client Secret](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/client-id-secret.png)

### Step 6: Setup authentication flow

Before proceeding with the Quickstart, ensure you have obtained the access token or refresh token using the following steps:

1. Create an authorization URL using the following format:

    ```
    https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES> redirect_uri=<YOUR_REDIRECT_URI>
    ```

    Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.

2. Paste it in the browser and select your developer test account to install the app when prompted.
    ![Account select](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/main/docs/resources/account-select.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following `curl` command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

    **Linux/macOS (Bash)**

    Use the following `curl` command in your terminal:

    ```bash
    curl --location "https://api.hubapi.com/oauth/v1/token" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --data-urlencode "grant_type=authorization_code" \
    --data-urlencode "code=<CODE>" \
    --data-urlencode "redirect_uri=<YOUR_REDIRECT_URI>" \
    --data-urlencode "client_id=<YOUR_CLIENT_ID>" \
    --data-urlencode "client_secret=<YOUR_CLIENT_SECRET>"
    ```

    **Windows (CMD)**

    Use the following `curl` command in Command Prompt:

    ```bash
    curl --location "https://api.hubapi.com/oauth/v1/token" ^
    --header "Content-Type: application/x-www-form-urlencoded" ^
    --data-urlencode "grant_type=authorization_code" ^
    --data-urlencode "code=<CODE>" ^
    --data-urlencode "redirect_uri=<YOUR_REDIRECT_URI>" ^
    --data-urlencode "client_id=<YOUR_CLIENT_ID>" ^
    --data-urlencode "client_secret=<YOUR_CLIENT_SECRET>"
    ```

    This command will return the access token and refresh token which are necessary for API calls.

    ```json
    {
        "token_type": "bearer",
        "refresh_token": "<Refresh Token>",
        "access_token": "<Access Token>",
        "expires_in": 1800
    }
    ```

5. Store the refresh token securely for use in your application.

6. If you are using testing tools (e.g., Postman, Insomnia) or need to manually refresh the token for testing, run the following `curl` command to refresh the access token when it expires, make a POST request to the HubSpot OAuth endpoint.
Replace the `<YOUR_REFRESH_TOKEN>`, `<YOUR_CLIENT_ID>`, and `<YOUR_CLIENT_SECRET>` with your specific value.

    **Linux/macOS (Bash)**

    Use the following `curl` command in your terminal:

    ```bash
    curl --request POST \
    --url https://api.hubapi.com/oauth/v1/token \
    --header 'content-type: application/x-www-form-urlencoded' \
    --data 'grant_type=refresh_token&refresh_token=<YOUR_REFRESH_TOKEN>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
    ```

    **Windows (CMD)**

    Use the following `curl` command in your command prompt:

    ```bash
    curl --request POST ^
    --url https://api.hubapi.com/oauth/v1/token ^
    --header 'content-type: application/x-www-form-urlencoded' ^
    --data 'grant_type=refresh_token&refresh_token=<YOUR_REFRESH_TOKEN>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
    ```

## Quickstart

To use the `Hubspot CRM Associations Schema` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.associations.schema` module and `oauth2` module.

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations.schema as hsschema;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

    ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
    ```

2. Instantiate a `hsschema:ConnectionConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;
    hsschema:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };
    final hsschema:Client hubspot = check new ({ auth });
    ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Read all association definitions from objects contact to deals

```ballerina
public function main() returns error? {
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging associations = 
        check hubspot->/contacts/deals/labels.get();
    io:println("Contact-Deal Association definitions: ", associations);
}
```

## Examples

The `HubSpot CRM Associations schema` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/tree/main/examples), covering the following use cases.

[//]: # (TODO: Add examples)

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

    ```bash
    ./gradlew clean build
    ```

2. To run the tests:

    ```bash
    ./gradlew clean test
    ```

3. To build the without the tests:

    ```bash
    ./gradlew clean build -x test
    ```

4. To run tests against different environments:

    ```bash
    ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
    ```

5. To debug the package with a remote debugger:

    ```bash
    ./gradlew clean build -Pdebug=<port>
    ```

6. To debug with the Ballerina language:

    ```bash
    ./gradlew clean build -PbalJavaDebug=<port>
    ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToCentral=true
    ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.associations.schema` package](https://central.ballerina.io/ballerinax/hubspot.crm.associations.schema/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
