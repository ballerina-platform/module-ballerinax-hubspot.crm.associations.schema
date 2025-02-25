import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations.schema as hsAssociationSchema;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

hsAssociationSchema:OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
final hsAssociationSchema:Client hubspot = check new ({auth});

// Function to create the association definition configuration payload for Create endpoint
function createConfigurationCreatePayload(int:Signed32 typeId, "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category, int:Signed32 maxToObjectIds) returns hsAssociationSchema:BatchInputPublicAssociationDefinitionConfigurationCreateRequest {
    return {
        inputs: [
            {
                typeId: typeId,
                category: category,
                maxToObjectIds: maxToObjectIds
            }
        ]
    };
}

// Function to create the association definition configuration payload for Update endpoint
function createConfigurationUpdatePayload(int:Signed32 typeId, "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category, int:Signed32 maxToObjectIds) returns hsAssociationSchema:BatchInputPublicAssociationDefinitionConfigurationUpdateRequest {
    return {
        inputs: [
            {
                typeId: typeId,
                category: category,
                maxToObjectIds: maxToObjectIds
            }
        ]
    };
}

// Function to create the association definition configuration
public function createConfiguration(hsAssociationSchema:BatchInputPublicAssociationDefinitionConfigurationCreateRequest payload, string fromObjectType, string toObjectType) returns hsAssociationSchema:BatchResponsePublicAssociationDefinitionUserConfiguration|error {
    hsAssociationSchema:BatchResponsePublicAssociationDefinitionUserConfiguration response = check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/create.post(payload);
    return response;
}

// Function to get the association definition configuration
public function getConfiguration(string fromObjectType, string toObjectType) returns hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error {
    hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging response = check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType].get();
    return response;
}

// Function to update the association definition configuration
public function updateConfiguration(hsAssociationSchema:BatchInputPublicAssociationDefinitionConfigurationUpdateRequest payload, string fromObjectType, string toObjectType) returns hsAssociationSchema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult|error {
    hsAssociationSchema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult response = check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/update.post(payload);
    return response;
}

// Function to handle status change and update configuration
function handleStatusChange(string fromObjectType, string toObjectType, int:Signed32 typeId, string status) returns error? {
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
    hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error getResponse = getConfiguration(fromObjectType, toObjectType);
    if (getResponse is hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging && getResponse.results[0].category == "HUBSPOT_DEFINED") {
        io:println(getResponse);
    } else {
        io:println("Error retrieving association definition configuration");
    }

    // Update association definition configuration
    hsAssociationSchema:BatchInputPublicAssociationDefinitionConfigurationUpdateRequest updatePayload = createConfigurationUpdatePayload(typeId, "HUBSPOT_DEFINED", maxToObjectIds);
    hsAssociationSchema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult|error updateResponse = updateConfiguration(updatePayload, fromObjectType, toObjectType);
    if (updateResponse is hsAssociationSchema:BatchResponsePublicAssociationDefinitionConfigurationUpdateResult && updateResponse.results[0].category == "HUBSPOT_DEFINED") {
        io:println("Association definition configuration updated successfully");
    } else {
        io:println("Error updating association definition configuration");
    }

    // Get association definition configuration after updating
    hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error getResponse2 = getConfiguration(fromObjectType, toObjectType);
    if (getResponse2 is hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging && getResponse2.results[0].category == "HUBSPOT_DEFINED") {
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
    hsAssociationSchema:BatchInputPublicAssociationDefinitionConfigurationCreateRequest createPayload = createConfigurationCreatePayload(typeId, "HUBSPOT_DEFINED", 2);
    hsAssociationSchema:BatchResponsePublicAssociationDefinitionUserConfiguration|error createResponse = createConfiguration(createPayload, fromObjectType, toObjectType);
    if (createResponse is hsAssociationSchema:BatchResponsePublicAssociationDefinitionUserConfiguration && createResponse.results[0].category == "HUBSPOT_DEFINED") {
        io:println("Association definition configuration created successfully");
    } else {
        io:println("Error creating association definition configuration");
    }

    // Periodically check for status changes and update configuration
    while true {
        io:println("Enter status (1: NORMAL, 2: SPECIAL, 3: EMERGENCY, 4: PANDEMIC): ");
        string? input = io:readln();
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