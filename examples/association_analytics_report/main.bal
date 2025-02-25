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

// Function to count different categories of configurations
function configurationsAnalysis() {
    hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error getAllResponse =
        hubspot->/definitions/configurations/all.get();
    if getAllResponse is hsAssociationSchema:CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging {
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
    hsAssociationSchema:CollectionResponseAssociationSpecWithLabelNoPaging|error getAssociationsResponse =
        hubspot->/[fromObjectType]/[toObjectType]/labels.get();
    if getAssociationsResponse is hsAssociationSchema:CollectionResponseAssociationSpecWithLabelNoPaging {
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
