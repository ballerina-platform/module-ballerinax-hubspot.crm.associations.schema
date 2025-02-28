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

import ballerina/http;
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

// Function to create the association definition payload for Create endpoint
function createAssociationDefinitionCreatePayload(string name, string label, string inverseLabel)
        returns hsschema:PublicAssociationDefinitionCreateRequest {
    return {
        inverseLabel,
        name,
        label
    };
}

// Function to create the association definition payload for update endpoint
function createAssociationDefinitionUpdatePayload(int:Signed32 associationTypeId, string label, string inverseLabel)
        returns hsschema:PublicAssociationDefinitionUpdateRequest {
    return {
        inverseLabel,
        associationTypeId,
        label
    };
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
        check hubspot->/[fromObjectType]/[toObjectType]/labels.post(CreatePayload);
    io:println("Association label created successfully\n");

    //Read association definitions
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging associationDefinitions =
        check hubspot->/[fromObjectType]/[toObjectType]/labels;
    io:println("Association definitions read: \n", associationDefinitions, "\n");

    // ID of the created association definition
    associationId = createdAssociationDefinition.results[0].typeId;
    inverseAssociationId = createdAssociationDefinition.results[1].typeId;

    // Create the association definition payload to update
    hsschema:PublicAssociationDefinitionUpdateRequest UpdatePayload =
        createAssociationDefinitionUpdatePayload(associationId, newLabel, newInverseLabel);

    // Update the association definition
    http:Response updateStatus = check hubspot->/[fromObjectType]/[toObjectType]/labels.put(UpdatePayload);
    if updateStatus.statusCode == 204 {
        io:println("Association label updated successfully\n");
    }

    // Delete the association definition
    http:Response deleteStatus = check hubspot->/[fromObjectType]/[toObjectType]/labels/[associationId].delete();
    http:Response inversDeleteStatus =
        check hubspot->/[fromObjectType]/[toObjectType]/labels/[inverseAssociationId].delete();
    if deleteStatus.statusCode == 204 && inversDeleteStatus.statusCode == 204 {
        io:println("Association definition with ID ", associationId, " has been deleted.");
    }
}
