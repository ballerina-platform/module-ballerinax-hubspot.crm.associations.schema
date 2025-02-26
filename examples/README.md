# Examples

The `ballerinax/hubspot.crm.associations.schema` connector provides practical examples illustrating usage in various scenarios.

1. [Association definition analytics report](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/examples/association_analytics_report) : Analyzes association definition configurations between object types (e.g., `contacts` to `deals`) in HubSpot, categorizing them and generating a count-based report.

2. [Automated association defnition configuration update](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/examples/automated_configuration_update) : Manages Doctor-Patient associations by updating them dynamically based on status changes (`Pandemic`, `Emergency`, `Normal`, `Special`).

3. [Association definition management](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/examples/companies_association_management) : Creates and manages custom associations (`Headquarters-Franchise`) between two `companies` objects, including reading, updating, and deleting associations.

4. [Custom association for a hospital system](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.associations.schema/examples/custom_association_for_hospital_system) : Creates a custom `Doctor_Patient` association between two `contacts` objects in a hospital CRM system.

## Prerequisites

1. Generate HubSpot credentials to authenticate the connector as described in the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.properties/blob/main/ballerina/Package.md#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
