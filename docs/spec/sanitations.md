_Author_:  @Aaishah-Hamdha \
_Created_: 2025/02/13 \
_Updated_: 2025/02/13 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Ballerina Hubspot CRM Associations Schema Connector
The OpenAPI specification is obtained from [Hubspot API Reference](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Associations%20Schema/Rollouts/130902/v4/associationsSchema.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Changed the `url` property of the servers object

- **Original**:
`https://api.hubspot.com`

- **Updated**:
`https://api.hubapi.com/crm/v4/associations`

- **Reason**: This change of adding the common prefix `crm/v4/associations` to the base url makes it easier to access endpoints using the client and also eliminates redundancy.

2. Updated the API Paths

- **Original**: Paths included common prefix above in each endpoint. (eg: `/crm/v4/associations`)
- **Updated**: Common prefix is now removed from the endpoints as it is included in the base URL.
- **Reason**: This change simplifies the API paths, making them shorter and more readable.

3. Updated the `date-time` into `datetime` to make it compatible with the Ballerina type conversions.

- **Original**:

  ```json
    { "format" : "date-time" }
  ```

- **Updated**:

  ```json
    { "format" : "datetime" }
  ```

- **Reason**: The `date-time` format is not compatible with the OpenAPI tool. Therefore, it is updated to `datetime` to make it compatible with the tool.

4. Updated the `label` and `userEnforcedMaxToObjectIds` properties in `PublicAssociationDefinitionUserConfiguration` to support nullable values.

- **Original**:

  ```json
    "PublicAssociationDefinitionUserConfiguration" : {
      "properties" : {
        "userEnforcedMaxToObjectIds" : {
          "type" : "integer",
          "format" : "int32",
        },
        "label" : {
          "type" : "string"
        }
      }
    }
  ```

- **Updated**:

  ```json
     "PublicAssociationDefinitionUserConfiguration" : {
        "properties" : {
          "userEnforcedMaxToObjectIds" : {
            "type" : "integer",
            "format" : "int32",
            "nullable": true
          },
          "label" : {
            "type" : "string",
            "nullable": true
          }
       }
     }
  ```

- **Reason**: The properties `userEnforcedMaxToObjectIds` and `label` are updated to be nullable, meaning they can either hold their respective values or be null, to fix a payload binding error.

5. Updated the `label` property in `PublicAssociationDefinitionCreateRequest` to suppoert nullable values.

- **Original**:

  ```json
     "PublicAssociationDefinitionCreateRequest" : {
        "properties" : {
        "label" : {
            "type" : "string"
          }
        }
      }
  ```

- **Updated**:

  ```json
     "PublicAssociationDefinitionCreateRequest" : {
        "properties" : {
          "label" : {
            "type" : "string",
            "nullable": true
          }
        }
      }
  ```

- **Reason**: The property `label` is updated to be nullable, meaning it can either hold its respective values or be null, to fix a payload binding error.

6. Updated the `label` property in `AssociationSpecWithLabel` to support nullable values

- **Original**:  

  ```json
      "AssociationSpecWithLabel" : {
        "properties" : {
          "label" : {
            "type" : "string"
          }
        }
      }
  ```

- **Updated**:

  ```json
      "AssociationSpecWithLabel" : {
        "properties" : {
          "label" : {
            "type" : "string",
            "nullable":true
          }
        }
      }
  ```

- **Reason**: The property `label` is updated to be nullable, meaning it can either hold its respective values or be null, to fix a payload binding error.

7. Updated the `label` property in `PublicAssociationDefinitionUpdateRequest` to support nullable values.

- **Original**:

  ```json
      "PublicAssociationDefinitionUpdateRequest" : {
        "properties" : {
          "label" : {
            "type" : "string"
          }
        }
      }
  ```

- **Updated**:

  ```json
      "PublicAssociationDefinitionUpdateRequest" : {
        "properties" : {
          "label" : {
            "type" : "string",
            "nullable": true
          }
        }
      }
  ```

- **Reason**: The property `label` is updated to be nullable, meaning it can either hold its respective values or be null, to fix a payload binding error.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```

Note: The license year is hardcoded to 2025, change if necessary.
