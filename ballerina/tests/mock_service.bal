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

service on new http:Listener(9090) {
    resource function delete [string fromObjectType]/[string toObjectType]/labels/[int:Signed32 associationTypeId]() returns http:NoContent|error {
        return http:NO_CONTENT;
    }
    resource function get [string fromObjectType]/[string toObjectType]/labels() returns CollectionResponseAssociationSpecWithLabelNoPaging|error {
        return {
            "results": [
                {
                    "category": "HUBSPOT_DEFINED",
                    "typeId": 4,
                    "label": null
                },
                {
                    "category": "USER_DEFINED",
                    "typeId": 543,
                    "label": "label"
                }
            ]
        };
    }
    resource function get definitions/configurations/[string fromObjectType]/[string toObjectType]() returns CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error {
        return {
            "results": [
                {
                    "category": "HUBSPOT_DEFINED",
                    "typeId": 4,
                    "userEnforcedMaxToObjectIds": 2,
                    "label": null
                }
            ]
        };
    }
    resource function get definitions/configurations/all() returns CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging|error {
        return {
            "results": [
                {
                    "category": "HUBSPOT_DEFINED",
                    "typeId": 4,
                    "userEnforcedMaxToObjectIds": 2,
                    "label": null
                },
                {
                    "category": "HUBSPOT_DEFINED",
                    "typeId": 3,
                    "userEnforcedMaxToObjectIds": null,
                    "label": null
                }
            ]
        };
    }
    resource function post [string fromObjectType]/[string toObjectType]/labels(@http:Payload PublicAssociationDefinitionCreateRequest payload) returns CollectionResponseAssociationSpecWithLabelNoPaging|http:BadRequest {
        if (payload.label == null) {
            return http:BAD_REQUEST;
        }
        return {
            "results": [
                {
                    "category": "USER_DEFINED",
                    "typeId": 546,
                    "label": "label"
                },
                {
                    "category": "USER_DEFINED",
                    "typeId": 545,
                    "label": "inverseLabel"
                }
            ]
        };
    }
    resource function post definitions/configurations/[string fromObjectType]/[string toObjectType]/batch/create(@http:Payload BatchInputPublicAssociationDefinitionConfigurationCreateRequest payload) returns BatchResponsePublicAssociationDefinitionUserConfiguration|error {
        if (payload.inputs[0].typeId == -1) {
            return {
                "status": "CANCELED",
                "results": [],
                "numErrors": 1,
                "errors": [
                    {
                        "status": "error",
                        "category": "VALIDATION_ERROR",
                        "subCategory": "crm.associations.INVALID_ASSOCIATION_TYPE",
                        "message": "0--1 is not a valid association type between CONTACT and DEAL",
                        "context": {
                            "type": [
                                "0-5"
                            ],
                            "fromObjectType": [
                                "CONTACT"
                            ],
                            "toObjectType": [
                                "DEAL"
                            ]
                        }
                    }
                ],
                "startedAt": "2025-02-19T07:03:44.442Z",
                "completedAt": "2025-02-19T07:03:44.475Z"
            };
        }
        return {
            "status": "COMPLETE",
            "results": [
                {
                    "category": "HUBSPOT_DEFINED",
                    "typeId": 4,
                    "userEnforcedMaxToObjectIds": 2,
                    "label": null
                }
            ],
            "startedAt": "2025-02-19T05:28:18.851Z",
            "completedAt": "2025-02-19T05:28:18.911Z"
        };
    }
    resource function post definitions/configurations/[string fromObjectType]/[string toObjectType]/batch/purge(@http:Payload BatchInputPublicAssociationSpec payload) returns http:NoContent|http:BadRequest|http:MultiStatus {
        if (payload.inputs[0].typeId == 5) {
            return http:BAD_REQUEST;
        }
        return http:NO_CONTENT;
    }
    resource function post definitions/configurations/[string fromObjectType]/[string toObjectType]/batch/update(@http:Payload BatchInputPublicAssociationDefinitionConfigurationUpdateRequest payload) returns BatchResponsePublicAssociationDefinitionConfigurationUpdateResult|error {
        if (payload.inputs[0].typeId == 5) {
            return {
                "status": "CANCELED",
                "results": [],
                "numErrors": 1,
                "errors": [
                    {
                        "status": "error",
                        "category": "VALIDATION_ERROR",
                        "subCategory": "crm.associations.INVALID_ASSOCIATION_TYPE",
                        "message": "0-5 is not a valid association type between CONTACT and DEAL",
                        "context": {
                            "type": [
                                "0-5"
                            ],
                            "fromObjectType": [
                                "CONTACT"
                            ],
                            "toObjectType": [
                                "DEAL"
                            ]
                        }
                    }
                ],
                "startedAt": "2025-02-19T07:03:44.442Z",
                "completedAt": "2025-02-19T07:03:44.475Z"
            };
        }
        return {
            "status": "COMPLETE",
            "results": [
                {
                    "category": "HUBSPOT_DEFINED",
                    "typeId": 4,
                    "userEnforcedMaxToObjectIds": 11
                }
            ],
            "startedAt": "2025-02-19T05:45:32.920Z",
            "completedAt": "2025-02-19T05:45:32.957Z"
        };
    }
    resource function put [string fromObjectType]/[string toObjectType]/labels(@http:Payload PublicAssociationDefinitionUpdateRequest payload) returns http:NoContent|http:BadRequest {
        if (payload.label == null || payload.associationTypeId == -1) {
            return http:BAD_REQUEST;
        }
        return http:NO_CONTENT;
    }
}
