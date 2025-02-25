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

// Function to count different categories of configurations
function configurationsAnalysis() {
    hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error getAllResponse =
        hubspot->/definitions/configurations/all.get();
    if getAllResponse is hsschema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging {
        int hubspotDefined = 0;
        int userDefined = 0;
        int integratorDefined = 0;
        int total = getAllResponse.results.length();

        foreach var config in getAllResponse.results {
            match config.category {
                "HUBSPOT_DEFINED" => {
                    hubspotDefined += 1;
                }
                "USER_DEFINED" => {
                    userDefined += 1;
                }
                "INTEGRATOR_DEFINED" => {
                    integratorDefined += 1;
                }
                _ => {
                }
            }
        }
        io:println("Total Configurations: ", total);
        io:println("HubSpot Defined: ", hubspotDefined);
        io:println("User Defined: ", userDefined);
        io:println("Integrator Defined: ", integratorDefined);
    } else {
        io:println("Error retrieving all association definition configurations");
    }
}

// Function to count different categories of definitions
function definitionsAnalysis(string fromObjectType, string toObjectType) {
    hsschema:CollectionResponseAssociationSpecWithLabelNoPaging|error getAssociationsResponse =
        hubspot->/[fromObjectType]/[toObjectType]/labels.get();
    if getAssociationsResponse is hsschema:CollectionResponseAssociationSpecWithLabelNoPaging {
        int hubspotDefined = 0;
        int userDefined = 0;
        int integratorDefined = 0;
        int total = getAssociationsResponse.results.length();

        foreach var config in getAssociationsResponse.results {
            match config.category {
                "HUBSPOT_DEFINED" => {
                    hubspotDefined += 1;
                }
                "USER_DEFINED" => {
                    userDefined += 1;
                }
                "INTEGRATOR_DEFINED" => {
                    integratorDefined += 1;
                }
                _ => {
                }
            }
        }
        io:println("\nTotal Association Definitions: ", total);
        io:println("HubSpot Defined: ", hubspotDefined);
        io:println("User Defined: ", userDefined);
        io:println("Integrator Defined: ", integratorDefined);
    } else {
        io:println("Error retrieving association definitions");
    }
}

// Main function to manage the association definition configuration
public function main() {
    // Count configurations
    configurationsAnalysis();
    // Analyze association definitions
    definitionsAnalysis("contacts", "deals"); // Example object types
}
