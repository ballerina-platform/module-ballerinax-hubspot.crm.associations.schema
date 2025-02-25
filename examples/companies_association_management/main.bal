import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.associations.schema as hsschema;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

hsschema:OAuth2RefreshTokenGrantConfig auth = {
    clientId: clientId,
    clientSecret: clientSecret,
    refreshToken: refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
final hsschema:Client hubspot = check new ({auth});

// Function to create the association definition payload for Create endpoint
function createAssociationDefinitionCreatePayload(string name, string label, string inverseLabel)
        returns hsschema:PublicAssociationDefinitionCreateRequest {
    return {
        inverseLabel: inverseLabel,
        name: name,
        label: label
    };
}

// Function to create the association definition payload for update endpoint
function createAssociationDefinitionUpdatePayload(int:Signed32 associationId, string label, string inverseLabel)
        returns hsschema:PublicAssociationDefinitionUpdateRequest {
    return {
        inverseLabel: inverseLabel,
        associationTypeId: associationId,
        label: label
    };
}

// Function to create the association definition
function createAssociationDefinition
        (hsschema:PublicAssociationDefinitionCreateRequest payload, string fromObjectType, string toObjectType)
        returns hsschema:CollectionResponseAssociationSpecWithLabelNoPaging|error {
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging response =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.post(payload);
    return response;
}

// Function to update the association definition
function updateAssociationDefinition
        (hsschema:PublicAssociationDefinitionUpdateRequest payload, string fromObjectType, string toObjectType)
        returns http:Response|error {
    http:Response response =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.put(payload);
    return response;
}

// Function to delete the association definition
function deleteAssociationDefinition(int:Signed32 associationId, string fromObjectType, string toObjectType)
returns http:Response|error {
    http:Response response = check hubspot->/[fromObjectType]/[toObjectType]/labels/[associationId].delete();
    return response;
}

// Main function to create, update, and delete the headquarters-franchise company association definition
public function main() returns error? {
    io:println("Managing Headquarters-Franchise company association...\n\n");

    final string fromObjectType = "companies";
    final string toObjectType = "companies";
    final string label = "Franchise company";
    final string labelName = "Headquarters_Franchise";
    final string inverseLabel = "Headquarters company";
    final string newLabel = "Franchise company updated";
    final string newInverseLabel = "Headquarters company updated";
    int:Signed32 associationId = -1;
    int:Signed32 inverseAssociationId = -1;

    // Create the association definition payload to create
    hsschema:PublicAssociationDefinitionCreateRequest CreatePayload =
        createAssociationDefinitionCreatePayload(labelName, label, inverseLabel);

    // Create the association definition
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging createdAssociationDefinition =
        check createAssociationDefinition(CreatePayload, fromObjectType, toObjectType);
    io:println("Association label created successfully\n");

    //Read association definitions
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging associationDefinitions =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.get();
    io:println("Association definitions read: \n", associationDefinitions, "\n");

    // ID of the created association definition
    associationId = createdAssociationDefinition.results[0].typeId;
    inverseAssociationId = createdAssociationDefinition.results[1].typeId;

    // Create the association definition payload to update
    hsschema:PublicAssociationDefinitionUpdateRequest UpdatePayload =
        createAssociationDefinitionUpdatePayload(associationId, newLabel, newInverseLabel);

    // Update the association definition
    http:Response updateStatus = check updateAssociationDefinition(UpdatePayload, fromObjectType, toObjectType);
    if (updateStatus.statusCode == 204) {
        io:println("Association label updated successfully\n");
    }

    // Delete the association definition
    http:Response deleteStatus = check deleteAssociationDefinition(associationId, fromObjectType, toObjectType);
    http:Response inversDeleteStatus =
        check deleteAssociationDefinition(inverseAssociationId, fromObjectType, toObjectType);
    if (deleteStatus.statusCode == 204 && inversDeleteStatus.statusCode == 204) {
        io:println("Association definition with ID ", associationId, " has been deleted.");
    }
}
