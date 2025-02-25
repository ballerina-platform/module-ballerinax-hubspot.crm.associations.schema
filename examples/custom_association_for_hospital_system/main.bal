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

// Function to create the association definition
function createAssociationDefinition
        (hsschema:PublicAssociationDefinitionCreateRequest payload, string fromObjectType, string toObjectType)
        returns hsschema:CollectionResponseAssociationSpecWithLabelNoPaging|error {
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging response =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.post(payload);
    return response;
}

// Main function 
public function main() returns error? {
    io:println("Creating Doctor_Patient association...\n\n");

    final string fromObjectType = "contacts";
    final string toObjectType = "contacts";
    final string label = "Doctor";
    final string labelName = "Doctor_Patient";
    final string inverseLabel = "Patient";

    // Create the association definition payload to create
    hsschema:PublicAssociationDefinitionCreateRequest CreatePayload =
            createAssociationDefinitionCreatePayload(labelName, label, inverseLabel);

    // Create the association definition
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging createdAssociationDefinition =
    check createAssociationDefinition(CreatePayload, fromObjectType, toObjectType);
    io:println("Association label created successfully\n");
    io:println(createdAssociationDefinition);
}
