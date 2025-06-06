// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is auto-generated by the Ballerina OpenAPI tool.

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

public type BatchResponsePublicAssociationDefinitionUserConfigurationWithErrors record {
    string completedAt;
    int:Signed32 numErrors?;
    string requestedAt?;
    string startedAt;
    record {|string...;|} links?;
    PublicAssociationDefinitionUserConfiguration[] results;
    StandardError[] errors?;
    "PENDING"|"PROCESSING"|"CANCELED"|"COMPLETE" status;
};

public type StandardError record {
    record {} subCategory?;
    record {|string[]...;|} context;
    record {|string...;|} links;
    string id?;
    string category;
    string message;
    ErrorDetail[] errors;
    string status;
};

public type PublicAssociationDefinitionCreateRequest record {
    string inverseLabel?;
    string name;
    string? label;
};

public type CollectionResponsePublicAssociationDefinitionUserConfigurationNoPaging record {
    PublicAssociationDefinitionUserConfiguration[] results;
};

public type BatchInputPublicAssociationSpec record {
    PublicAssociationSpec[] inputs;
};

public type BatchResponsePublicAssociationDefinitionConfigurationUpdateResult record {
    string completedAt;
    string requestedAt?;
    string startedAt;
    record {|string...;|} links?;
    PublicAssociationDefinitionConfigurationUpdateResult[] results;
    "PENDING"|"PROCESSING"|"CANCELED"|"COMPLETE" status;
};

public type PublicAssociationDefinitionConfigurationUpdateResult record {
    int:Signed32 userEnforcedMaxToObjectIds?;
    int:Signed32 typeId;
    "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category;
};

public type PublicAssociationDefinitionConfigurationUpdateRequest record {
    int:Signed32 typeId;
    "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category;
    int:Signed32 maxToObjectIds;
};

public type PublicAssociationDefinitionConfigurationCreateRequest record {
    int:Signed32 typeId;
    "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category;
    int:Signed32 maxToObjectIds;
};

public type PublicAssociationDefinitionUpdateRequest record {
    string inverseLabel?;
    int:Signed32 associationTypeId;
    string? label;
};

public type ErrorDetail record {
    # A specific category that contains more specific detail about the error
    string subCategory?;
    # The status code associated with the error detail
    string code?;
    # The name of the field or parameter in which the error was found
    string 'in?;
    # Context about the error condition
    record {|string[]...;|} context?;
    # A human readable message describing the error along with remediation steps where appropriate
    string message;
};

public type AssociationSpecWithLabel record {
    int:Signed32 typeId;
    string? label?;
    "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category;
};

public type CollectionResponseAssociationSpecWithLabelNoPaging record {
    AssociationSpecWithLabel[] results;
};

public type PublicAssociationDefinitionUserConfiguration record {
    int:Signed32? userEnforcedMaxToObjectIds?;
    int:Signed32 typeId;
    string? label?;
    "HUBSPOT_DEFINED"|"USER_DEFINED"|"INTEGRATOR_DEFINED" category;
};

public type BatchResponsePublicAssociationDefinitionUserConfiguration record {
    string completedAt;
    string requestedAt?;
    string startedAt;
    record {|string...;|} links?;
    PublicAssociationDefinitionUserConfiguration[] results;
    "PENDING"|"PROCESSING"|"CANCELED"|"COMPLETE" status;
};

# OAuth2 Refresh Token Grant Configs
public type OAuth2RefreshTokenGrantConfig record {|
    *http:OAuth2RefreshTokenGrantConfig;
    # Refresh URL
    string refreshUrl = "https://api.hubapi.com/oauth/v1/token";
|};

public type BatchInputPublicAssociationDefinitionConfigurationUpdateRequest record {
    PublicAssociationDefinitionConfigurationUpdateRequest[] inputs;
};

# Provides API key configurations needed when communicating with a remote HTTP endpoint.
public type ApiKeysConfig record {|
    string privateAppLegacy;
    string privateApp;
|};

public type BatchResponsePublicAssociationDefinitionConfigurationUpdateResultWithErrors record {
    string completedAt;
    int:Signed32 numErrors?;
    string requestedAt?;
    string startedAt;
    record {|string...;|} links?;
    PublicAssociationDefinitionConfigurationUpdateResult[] results;
    StandardError[] errors?;
    "PENDING"|"PROCESSING"|"CANCELED"|"COMPLETE" status;
};

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Provides Auth configurations needed when communicating with a remote HTTP endpoint.
    http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig|ApiKeysConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 30;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects followRedirects?;
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with cookies
    http:CookieConfig cookieConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Provides settings related to client socket configuration
    http:ClientSocketConfig socketConfig = {};
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
    # Enables relaxed data binding on the client side. When enabled, `nil` values are treated as optional, 
    # and absent fields are handled as `nilable` types. Enabled by default.
    boolean laxDataBinding = true;
|};

public type BatchInputPublicAssociationDefinitionConfigurationCreateRequest record {
    PublicAssociationDefinitionConfigurationCreateRequest[] inputs;
};

public type PublicAssociationSpec record {
    int:Signed32 typeId;
    string category;
};
