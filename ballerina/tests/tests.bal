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
import ballerina/oauth2;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v4/associations" :
    "http://localhost:9090";

final string clientId = os:getEnv("HUBSPOT_CLIENT_ID");
final string clientSecret = os:getEnv("HUBSPOT_CLIENT_SECRET");
final string refreshToken = os:getEnv("HUBSPOT_REFRESH_TOKEN");

final string fromObjectType = "contacts";
final string toObjectType = "deals";

final string label = "Label";
final string inverseLabel = "InverseLabel";
final string labelName = "LabelName";
final string labelToUpdate = "LabelNew";

isolated int:Signed32 createdInverseLabelId = -1;
isolated int:Signed32 createdLabelId = -1;
final int:Signed32 typeId = 4; //association type id for contact to deals association

//init client
final Client hubspot = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new Client({auth}, serviceUrl);
    }
    return check new Client({auth: {token: "test-token"}}, serviceUrl);
}

//Association definition Tests
//Test: Create association definitions
@test:Config {groups: ["live_test", "mock_test"]}
isolated function testCreateAssociationDefinitions() returns error? {
    PublicAssociationDefinitionCreateRequest payload = {
        inverseLabel,
        name: labelName,
        label
    };
    CollectionResponseAssociationSpecWithLabelNoPaging response =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.post(payload);
    if response.results.length() > 0 {
        lock {
            createdLabelId = response.results[0].typeId;
        }
        lock {
            createdInverseLabelId = response.results[1].typeId;
        }
    }
    test:assertTrue(response.results.length() > 0, msg =
            "No association definitions were created.");
    test:assertEquals(response.results.length(), 2, msg =
            "Unexpected behavior on association definition creation.");
}

//Test: Update association definitions
@test:Config {dependsOn: [testCreateAssociationDefinitions], groups: ["live_test", "mock_test"]}
isolated function testUpdateAssociationDefinitions() returns error? {
    int response1StatusCode = -1;
    int response2StatusCode = -1;
    lock {
        PublicAssociationDefinitionUpdateRequest payload = {
            associationTypeId: createdLabelId,
            label: labelToUpdate
        };
        http:Response response1 =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.put(payload);
        response1StatusCode = response1.statusCode;
    }
    lock {
        PublicAssociationDefinitionUpdateRequest payload = {
            associationTypeId: createdInverseLabelId,
            label: labelToUpdate
        };
        http:Response response2 =
        check hubspot->/[fromObjectType]/[toObjectType]/labels.put(payload);
        response2StatusCode = response2.statusCode;
    }
    test:assertTrue(response1StatusCode == 204 || response2StatusCode == 204,
            msg = "Association label update failed for both createdLabelId and createdInverseLabelId");
}

//Test: Read association definitions
@test:Config {dependsOn: [testCreateAssociationDefinitions], groups: ["live_test", "mock_test"]}
isolated function testGetAssociationDefinitions() returns error? {
    CollectionResponseAssociationSpecWithLabelNoPaging response =
        check hubspot->/[fromObjectType]/[toObjectType]/labels;
    test:assertTrue(response.results.length() > 0,
            msg = "No definitions were returned");
    test:assertEquals(response.results.length(), 2,
            msg = "Unexpected behavior on association definition retrieval.");
}

//Test: Delete association definitions
@test:Config {dependsOn: [testGetAssociationDefinitions], groups: ["live_test", "mock_test"]}
isolated function testDeleteAssociationDefinitions() returns error? {
    lock {
        http:Response response1 = check hubspot->/[fromObjectType]/[toObjectType]/labels/[createdLabelId].delete();
        test:assertEquals(response1.statusCode, 204, msg = "Association definition deletion failed");
    }
    lock {
        http:Response response2 =
            check hubspot->/[fromObjectType]/[toObjectType]/labels/[createdInverseLabelId].delete();
        test:assertEquals(response2.statusCode, 204, msg = "Association definition deletion failed");
    }
}

//Association definition Configurations Tests
//Test: Create association definition Configurations
@test:Config {groups: ["live_test", "mock_test"]}
isolated function testCreateAssociationDefinitionConfigurations() returns error? {
    BatchInputPublicAssociationDefinitionConfigurationCreateRequest payload = {
        inputs: [
            {
                typeId,
                category: "HUBSPOT_DEFINED",
                maxToObjectIds: 2
            }
        ]
    };
    CollectionResponseAssociationSpecWithLabelNoPaging response =
        check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/create.post(payload);
    test:assertTrue(response.results.length() > 0, msg =
            "No definition configurations were created.");
    test:assertEquals(response.results.length(), 1, msg =
            "Unexpected behavior on definition configuration creation.");
}

//Test: Read ALL configurations
@test:Config {dependsOn: [testCreateAssociationDefinitionConfigurations], groups: ["live_test", "mock_test"]}
isolated function testGetAllDefinitionsConfigurations() returns error? {
    CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging response =
        check hubspot->/definitions/configurations/all;
    test:assertTrue(response.results.length() > 0,
            msg = "No configurations were returned.");
    test:assertEquals(response.results.length(), 2,
            msg = "Unexpected behavior on all configurations retrieval.");
}

//Test: Read association definition configurations
@test:Config {dependsOn: [testCreateAssociationDefinitionConfigurations], groups: ["live_test", "mock_test"]}
isolated function testGetAssociationDefinitionConfigurations() returns error? {
    CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging response =
        check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType];
    test:assertTrue(response.results.length() > 0, msg =
            "No  association definition configurations were returned.");
}

//Test: Update configurations
@test:Config {dependsOn: [testCreateAssociationDefinitionConfigurations], groups: ["live_test", "mock_test"]}
isolated function testUpdateAssociationDefinitionConfigurations() returns error? {
    BatchInputPublicAssociationDefinitionConfigurationUpdateRequest payload = {
        inputs: [
            {
                typeId,
                category: "HUBSPOT_DEFINED",
                maxToObjectIds: 11
            }
        ]
    };
    BatchResponsePublicAssociationDefinitionConfigurationUpdateResult response =
        check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/update.post(payload);
    test:assertTrue(response.results.length() > 0,
            msg = "Failed to update association definition configuration.");
    test:assertEquals(response.status, "COMPLETE",
            msg = "Unexpected behavior for definition configuration update.");
}

//Test:Delete association definition configurations
@test:Config {dependsOn: [testUpdateAssociationDefinitionConfigurations], groups: ["live_test", "mock_test"]}
isolated function testDeleteAssociationDefinitionConfigurations() returns error? {
    BatchInputPublicAssociationSpec payload = {
        inputs: [
            {
                typeId,
                category: "HUBSPOT_DEFINED"
            }
        ]
    };
    http:Response response =
    check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/purge.post(payload);

    test:assertEquals(response.statusCode, 204,
            msg = "Unexpected behavior for definition configuration deletion.");
}

//negative test cases
//Test(negative): Update association definition with invalid data
@test:Config {groups: ["live_test", "mock_test"]}
isolated function testUpdateAssociationDefinitionsInvalidData() returns error? {
    PublicAssociationDefinitionUpdateRequest payload = {
        associationTypeId: -1, // Invalid associationTypeId
        label: "" // Invalid empty label
    };
    http:Response response = check hubspot->/[fromObjectType]/[toObjectType]/labels.put(payload);
    test:assertEquals(response.statusCode, 400, msg = "Unexpected behavior for invalid data.");
}

//Test(negative): Create association definition configuration with invalid data
@test:Config {groups: ["live_test", "mock_test"]}
isolated function testCreateAssociationDefinitionConfigurationsInvalidData() returns error? {
    BatchInputPublicAssociationDefinitionConfigurationCreateRequest payload = {
        inputs: [
            {
                typeId: -1, // Invalid associationTypeId
                category: "HUBSPOT_DEFINED",
                maxToObjectIds: 2
            }
        ]
    };
    BatchResponsePublicAssociationDefinitionUserConfiguration response =
        check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/create.post(payload);
    test:assertEquals(response.status, "CANCELED", msg = "Unexpected behavior for invalid data.");
}

//Test(negative): Update association definition configuration with invalid data
@test:Config {groups: ["live_test", "mock_test"]}
isolated function testUpdateAssociationDefinitionConfigurationsInvalidId() returns error? {
    BatchInputPublicAssociationDefinitionConfigurationUpdateRequest payload = {
        inputs: [
            {
                typeId: 5, //invalid type id for contact to deals association
                category: "USER_DEFINED",
                maxToObjectIds: 5
            }
        ]
    };
    BatchResponsePublicAssociationDefinitionConfigurationUpdateResult response =
        check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/update.post(payload);
    test:assertEquals(response.status, "CANCELED",
            msg = "Unexpected behavior for invalid association type id.");
}

//Test(negative): Delete association definition configuration with invalid data
@test:Config {groups: ["live_test", "mock_test"]}
isolated function testDeleteAssociationDefinitionConfigurationsWithInvalidData() returns error? {
    BatchInputPublicAssociationSpec payload = {
        inputs: [
            {
                typeId: 5, //invalid type id for contact to deals association
                category: "HUBSPOT_DEFINED"
            }
        ]
    };
    http:Response response =
    check hubspot->/definitions/configurations/[fromObjectType]/[toObjectType]/batch/purge.post(payload);
    test:assertTrue(response.statusCode == 207 || response.statusCode == 400,
            msg = "Unexpected behavior for invalid association type id.");
}
