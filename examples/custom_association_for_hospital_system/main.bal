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

// Function to create the association definition payload for Create endpoint
function createAssociationDefinitionCreatePayload(string name, string label, string inverseLabel)
        returns hsAssociationSchema:PublicAssociationDefinitionCreateRequest {
    return {
        inverseLabel: inverseLabel,
        name: name,
        label: label
    };
}

// Function to create the association definition
function createAssociationDefinition
        (hsAssociationSchema:PublicAssociationDefinitionCreateRequest payload, string fromObjectType, string toObjectType)
        returns hsAssociationSchema:CollectionResponseAssociationSpecWithLabelNoPaging|error {
    hsAssociationSchema:CollectionResponseAssociationSpecWithLabelNoPaging response =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.post(payload);
    return response;
}

// Main function 
public function main() returns error? {
    io:println("Creating Doctor_Patient company association...\n\n");

    final string fromObjectType = "contacts";
    final string toObjectType = "contacts";
    final string label = "Doctor";
    final string labelName = "Doctor_Patient";
    final string inverseLabel = "Patient";

    // Create the association definition payload to create
    hsAssociationSchema:PublicAssociationDefinitionCreateRequest CreatePayload =
            createAssociationDefinitionCreatePayload(labelName, label, inverseLabel);

    // Create the association definition
    hsAssociationSchema:CollectionResponseAssociationSpecWithLabelNoPaging createdAssociationDefinition =
    check createAssociationDefinition(CreatePayload, fromObjectType, toObjectType);
    io:println("Association label created successfully\n");
    io:println(createdAssociationDefinition);
}
