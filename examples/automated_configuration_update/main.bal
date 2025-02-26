// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations.schema as hsschema;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

hsschema:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
final hsschema:Client hubspot = check new ({auth});

// Function to create the association definition configuration payload for Create endpoint
function createConfigurationCreatePayload
(int:Signed32 typeId, "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category, int:Signed32 maxToObjectIds)
returns hsschema:BatchInputPublicAssociationDefinitionConfigurationCreateRequest {
    return {
        inputs: [
            {
                typeId,
                category,
                maxToObjectIds
            }
        ]
    };
}

// Function to create the association definition configuration payload for Update endpoint
function createConfigurationUpdatePayload
(int:Signed32 typeId, "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category, int:Signed32 maxToObjectIds)
returns hsschema:BatchInputPublicAssociationDefinitionConfigurationUpdateRequest {
    return {
        inputs: [
            {
                typeId,
                category,
                maxToObjectIds
            }
        ]
    };
}

// Function to create the association definition configuration
public function createConfiguration
        (
        hsschema:BatchInputPublicAssociationDefinitionConfigurationCreateRequest payload,
        string fromObjectType,
        string toObjectType
    )
returns hsschema:BatchResponsePublicAssociationDefinitionUserConfiguration|error {
    hsschema:BatchResponsePublicAssociationDefinitionUserConfiguration response =
    check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/create.post(payload);
    return response;
}

// Function to get the association definition configuration
public function getConfiguration(string fromObjectType, string toObjectType)
returns hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error {
    hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging response =
    check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType].get();
    return response;
}

// Function to update the association definition configuration
public function updateConfiguration
        (
        hsschema:BatchInputPublicAssociationDefinitionConfigurationUpdateRequest payload,
        string fromObjectType,
        string toObjectType
    )
returns hsschema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult|error {
    hsschema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult response =
    check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/update.post(payload);
    return response;
}

// Function to handle status change and update configuration
function handleStatusChange
(string fromObjectType, string toObjectType, int:Signed32 typeId, string status)
returns error? {
    int:Signed32 maxToObjectIds = 0; // Initialize maxToObjectIds
    if status == "NORMAL" {
        maxToObjectIds = 2;
    } else if status == "SPECIAL" {
        maxToObjectIds = 1;
    } else if status == "EMERGENCY" {
        maxToObjectIds = 5;
    } else if status == "PANDEMIC" {
        maxToObjectIds = 10;
    }

    // Get association definition configuration before updating
    hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error getResponse =
    getConfiguration(fromObjectType, toObjectType);
    if (getResponse is hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging
        && getResponse.results[0].category == "HUBSPOT_DEFINED") {
        io:println(getResponse);
    } else {
        io:println("Error retrieving association definition configuration");
    }

    // Update association definition configuration
    hsschema:BatchInputPublicAssociationDefinitionConfigurationUpdateRequest updatePayload =
        createConfigurationUpdatePayload(typeId, "HUBSPOT_DEFINED", maxToObjectIds);
    hsschema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult|error updateResponse =
    updateConfiguration(updatePayload, fromObjectType, toObjectType);
    if (updateResponse is hsschema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult
        && updateResponse.results[0].category == "HUBSPOT_DEFINED") {
        io:println("Association definition configuration updated successfully");
    } else {
        io:println("Error updating association definition configuration");
    }

    // Get association definition configuration after updating
    hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error getResponse2 =
    getConfiguration(fromObjectType, toObjectType);
    if (getResponse2 is hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging
        && getResponse2.results[0].category == "HUBSPOT_DEFINED") {
        io:println(getResponse2);
    } else {
        io:println("Error retrieving association definition configuration");
    }
}

public function main() returns error? {
    final string fromObjectType = "contacts";
    final string toObjectType = "contacts";
    final int:Signed32 typeId = 449;
    string status = "NORMAL";
    string newStatus = "NORMAL";

    // Create association definition configuration
    hsschema:BatchInputPublicAssociationDefinitionConfigurationCreateRequest createPayload =
        createConfigurationCreatePayload(typeId, "HUBSPOT_DEFINED", 2);
    hsschema:BatchResponsePublicAssociationDefinitionUserConfiguration|error createResponse =
        createConfiguration(createPayload, fromObjectType, toObjectType);
    if (createResponse is hsschema:BatchResponsePublicAssociationDefinitionUserConfiguration
        && createResponse.results[0].category == "HUBSPOT_DEFINED") {
        io:println("Association definition configuration created successfully");
    } else {
        io:println("Error creating association definition configuration");
    }

    // Periodically check for status changes and update configuration
    while true {
        io:println("Enter status (1: NORMAL, 2: SPECIAL, 3: EMERGENCY, 4: PANDEMIC) or x: exit: ");
        string? input = io:readln();
        if input == "x" || input == "X" {
            break;
        }
        match input {
            "1" => {
                newStatus = "NORMAL";
            }
            "2" => {
                newStatus = "SPECIAL";
            }
            "3" => {
                newStatus = "EMERGENCY";
            }
            "4" => {
                newStatus = "PANDEMIC";
            }
            _ => {
                io:println("Invalid input. Please enter a valid status.");
                continue;
            }
        }

        if newStatus != status {
            status = newStatus;
            io:println("Status: ", status);
            check handleStatusChange(fromObjectType, toObjectType, typeId, status);
        }
    }
}
