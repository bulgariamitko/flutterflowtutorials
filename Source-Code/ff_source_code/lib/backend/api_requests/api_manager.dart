// ignore_for_file: constant_identifier_names, depend_on_referenced_packages, prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import '/flutter_flow/uploaded_file.dart';

import 'get_streamed_response.dart';

enum ApiCallType {
  GET,
  POST,
  DELETE,
  PUT,
  PATCH,
}

enum BodyType {
  NONE,
  JSON,
  TEXT,
  X_WWW_FORM_URL_ENCODED,
  MULTIPART,
}

class ApiCallOptions extends Equatable {
  const ApiCallOptions({
    this.callName = '',
    required this.callType,
    required this.apiUrl,
    required this.headers,
    required this.params,
    this.bodyType,
    this.body,
    this.returnBody = true,
    this.encodeBodyUtf8 = false,
    this.decodeUtf8 = false,
    this.alwaysAllowBody = false,
    this.cache = false,
    this.isStreamingApi = false,
  });

  final String callName;
  final ApiCallType callType;
  final String apiUrl;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> params;
  final BodyType? bodyType;
  final String? body;
  final bool returnBody;
  final bool encodeBodyUtf8;
  final bool decodeUtf8;
  final bool alwaysAllowBody;
  final bool cache;
  final bool isStreamingApi;

  /// Creates a new [ApiCallOptions] with optionally updated parameters.
  ///
  /// This helper function allows creating a copy of the current options while
  /// selectively modifying specific fields. Any parameter that is not provided
  /// will retain its original value from the current instance.
  ApiCallOptions copyWith({
    String? callName,
    ApiCallType? callType,
    String? apiUrl,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    BodyType? bodyType,
    String? body,
    bool? returnBody,
    bool? encodeBodyUtf8,
    bool? decodeUtf8,
    bool? alwaysAllowBody,
    bool? cache,
    bool? isStreamingApi,
  }) {
    return ApiCallOptions(
      callName: callName ?? this.callName,
      callType: callType ?? this.callType,
      apiUrl: apiUrl ?? this.apiUrl,
      headers: headers ?? _cloneMap(this.headers),
      params: params ?? _cloneMap(this.params),
      bodyType: bodyType ?? this.bodyType,
      body: body ?? this.body,
      returnBody: returnBody ?? this.returnBody,
      encodeBodyUtf8: encodeBodyUtf8 ?? this.encodeBodyUtf8,
      decodeUtf8: decodeUtf8 ?? this.decodeUtf8,
      alwaysAllowBody: alwaysAllowBody ?? this.alwaysAllowBody,
      cache: cache ?? this.cache,
      isStreamingApi: isStreamingApi ?? this.isStreamingApi,
    );
  }

  ApiCallOptions clone() => ApiCallOptions(
        callName: callName,
        callType: callType,
        apiUrl: apiUrl,
        headers: _cloneMap(headers),
        params: _cloneMap(params),
        bodyType: bodyType,
        body: body,
        returnBody: returnBody,
        encodeBodyUtf8: encodeBodyUtf8,
        decodeUtf8: decodeUtf8,
        alwaysAllowBody: alwaysAllowBody,
        cache: cache,
        isStreamingApi: isStreamingApi,
      );

  @override
  List<Object?> get props => [
        callName,
        callType.name,
        apiUrl,
        headers,
        params,
        bodyType,
        body,
        returnBody,
        encodeBodyUtf8,
        decodeUtf8,
        alwaysAllowBody,
        cache,
        isStreamingApi,
      ];

  static Map<String, dynamic> _cloneMap(Map<String, dynamic> map) {
    try {
      return json.decode(json.encode(map)) as Map<String, dynamic>;
    } catch (_) {
      return Map.from(map);
    }
  }
}

class ApiCallResponse {
  const ApiCallResponse(
    this.jsonBody,
    this.headers,
    this.statusCode, {
    this.response,
    this.streamedResponse,
    this.exception,
  });
  final dynamic jsonBody;
  final Map<String, String> headers;
  final int statusCode;
  final http.Response? response;
  final http.StreamedResponse? streamedResponse;
  final Object? exception;
  // Whether we received a 2xx status (which generally marks success).
  bool get succeeded => statusCode >= 200 && statusCode < 300;
  String getHeader(String headerName) => headers[headerName] ?? '';
  // Return the raw body from the response, or if this came from a cloud call
  // and the body is not a string, then the json encoded body.
  String get bodyText =>
      response?.body ??
      (jsonBody is String ? jsonBody as String : jsonEncode(jsonBody));
  String get exceptionMessage => exception.toString();

  /// Creates a new [ApiCallResponse] with optionally updated parameters.
  ///
  /// This helper function allows creating a copy of the current response while
  /// selectively modifying specific fields. Any parameter that is not provided
  /// will retain its original value from the current instance.
  ApiCallResponse copyWith({
    dynamic jsonBody,
    Map<String, String>? headers,
    int? statusCode,
    http.Response? response,
    http.StreamedResponse? streamedResponse,
    Object? exception,
  }) {
    return ApiCallResponse(
      jsonBody ?? this.jsonBody,
      headers ?? this.headers,
      statusCode ?? this.statusCode,
      response: response ?? this.response,
      streamedResponse: streamedResponse ?? this.streamedResponse,
      exception: exception ?? this.exception,
    );
  }

  static ApiCallResponse fromHttpResponse(
    http.Response response,
    bool returnBody,
    bool decodeUtf8,
  ) {
    dynamic jsonBody;
    try {
      final responseBody = decodeUtf8 && returnBody
          ? const Utf8Decoder().convert(response.bodyBytes)
          : response.body;
      jsonBody = returnBody ? json.decode(responseBody) : null;
    } catch (_) {}
    return ApiCallResponse(
      jsonBody,
      response.headers,
      response.statusCode,
      response: response,
    );
  }

  static ApiCallResponse fromCloudCallResponse(Map<String, dynamic> response) =>
      ApiCallResponse(
        response['body'],
        ApiManager.toStringMap(response['headers'] ?? {}),
        response['statusCode'] ?? 400,
      );
}

class ApiManager {
  ApiManager._();

  // Cache that will ensure identical calls are not repeatedly made.
  static Map<ApiCallOptions, ApiCallResponse> _apiCache = {};

  static ApiManager? _instance;
  static ApiManager get instance => _instance ??= ApiManager._();

  // If your API calls need authentication, populate this field once
  // the user has authenticated. Alter this as needed.
  static String? _accessToken;
  // You may want to call this if, for example, you make a change to the
  // database and no longer want the cached result of a call that may
  // have changed.
  static void clearCache(String callName) => _apiCache.keys
      .toSet()
      .forEach((k) => k.callName == callName ? _apiCache.remove(k) : null);

  static Map<String, String> toStringMap(Map map) =>
      map.map((key, value) => MapEntry(key.toString(), value.toString()));

  static String asQueryParams(Map<String, dynamic> map) => map.entries
      .map((e) =>
          "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}")
      .join('&');

  static Future<ApiCallResponse> urlRequest(
    ApiCallType callType,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    bool returnBody,
    bool decodeUtf8,
    bool isStreamingApi, {
    http.Client? client,
  }) async {
    if (params.isNotEmpty) {
      final specifier =
          Uri.parse(apiUrl).queryParameters.isNotEmpty ? '&' : '?';
      apiUrl = '$apiUrl$specifier${asQueryParams(params)}';
    }
    if (isStreamingApi) {
      client ??= http.Client();
      final request =
          http.Request(callType.toString().split('.').last, Uri.parse(apiUrl))
            ..headers.addAll(toStringMap(headers));
      final streamedResponse = await getStreamedResponse(request);
      return ApiCallResponse(
        null,
        streamedResponse.headers,
        streamedResponse.statusCode,
        streamedResponse: streamedResponse,
      );
    }
    final makeRequest = callType == ApiCallType.GET
        ? (client != null ? client.get : http.get)
        : (client != null ? client.delete : http.delete);
    final response =
        await makeRequest(Uri.parse(apiUrl), headers: toStringMap(headers));
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static Future<ApiCallResponse> requestWithBody(
    ApiCallType type,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    String? body,
    BodyType? bodyType,
    bool returnBody,
    bool encodeBodyUtf8,
    bool decodeUtf8,
    bool alwaysAllowBody,
    bool isStreamingApi, {
    http.Client? client,
  }) async {
    assert(
      {ApiCallType.POST, ApiCallType.PUT, ApiCallType.PATCH}.contains(type) ||
          (alwaysAllowBody && type == ApiCallType.DELETE),
      'Invalid ApiCallType $type for request with body',
    );
    final postBody =
        createBody(headers, params, body, bodyType, encodeBodyUtf8);
    if (isStreamingApi) {
      client ??= http.Client();
      final request =
          http.Request(type.toString().split('.').last, Uri.parse(apiUrl))
            ..headers.addAll(toStringMap(headers));
      request.body = postBody;
      final streamedResponse = await getStreamedResponse(request);
      return ApiCallResponse(
        null,
        streamedResponse.headers,
        streamedResponse.statusCode,
        streamedResponse: streamedResponse,
      );
    }

    if (bodyType == BodyType.MULTIPART) {
      return multipartRequest(type, apiUrl, headers, params, returnBody,
          decodeUtf8, alwaysAllowBody);
    }

    final requestFn = {
      ApiCallType.POST: client != null ? client.post : http.post,
      ApiCallType.PUT: client != null ? client.put : http.put,
      ApiCallType.PATCH: client != null ? client.patch : http.patch,
      ApiCallType.DELETE: client != null ? client.delete : http.delete,
    }[type]!;
    final response = await requestFn(Uri.parse(apiUrl),
        headers: toStringMap(headers), body: postBody);
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static Future<ApiCallResponse> multipartRequest(
    ApiCallType? type,
    String apiUrl,
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    bool returnBody,
    bool decodeUtf8,
    bool alwaysAllowBody,
  ) async {
    assert(
      {ApiCallType.POST, ApiCallType.PUT, ApiCallType.PATCH}.contains(type) ||
          (alwaysAllowBody && type == ApiCallType.DELETE),
      'Invalid ApiCallType $type for request with body',
    );

    bool isFile(dynamic e) =>
        e is FFUploadedFile ||
        e is List<FFUploadedFile> ||
        (e is List && e.firstOrNull is FFUploadedFile);

    final nonFileParams = toStringMap(
        Map.fromEntries(params.entries.where((e) => !isFile(e.value))));

    List<http.MultipartFile> files = [];
    params.entries.where((e) => isFile(e.value)).forEach((e) {
      final param = e.value;
      final uploadedFiles = param is List
          ? param as List<FFUploadedFile>
          : [param as FFUploadedFile];
      for (var uploadedFile in uploadedFiles) {
        files.add(
          http.MultipartFile.fromBytes(
            e.key,
            uploadedFile.bytes ?? Uint8List.fromList([]),
            filename: uploadedFile.name,
            contentType: _getMediaType(uploadedFile.name),
          ),
        );
      }
    });

    final request = http.MultipartRequest(
        type.toString().split('.').last, Uri.parse(apiUrl))
      ..headers.addAll(toStringMap(headers))
      ..files.addAll(files);
    nonFileParams.forEach((key, value) => request.fields[key] = value);

    final response = await http.Response.fromStream(await request.send());
    return ApiCallResponse.fromHttpResponse(response, returnBody, decodeUtf8);
  }

  static MediaType? _getMediaType(String? filename) {
    final contentType = mime(filename);
    if (contentType == null) {
      return null;
    }
    final parts = contentType.split('/');
    if (parts.length != 2) {
      return null;
    }
    return MediaType(parts.first, parts.last);
  }

  static dynamic createBody(
    Map<String, dynamic> headers,
    Map<String, dynamic>? params,
    String? body,
    BodyType? bodyType,
    bool encodeBodyUtf8,
  ) {
    String? contentType;
    dynamic postBody;
    switch (bodyType) {
      case BodyType.JSON:
        contentType = 'application/json';
        postBody = body ?? json.encode(params ?? {});
        break;
      case BodyType.TEXT:
        contentType = 'text/plain';
        postBody = body ?? json.encode(params ?? {});
        break;
      case BodyType.X_WWW_FORM_URL_ENCODED:
        contentType = 'application/x-www-form-urlencoded';
        postBody = toStringMap(params ?? {});
        break;
      case BodyType.MULTIPART:
        contentType = 'multipart/form-data';
        postBody = params;
        break;
      case BodyType.NONE:
      case null:
        break;
    }
    // Set "Content-Type" header if it was previously unset.
    if (contentType != null &&
        !headers.keys.any((h) => h.toLowerCase() == 'content-type')) {
      headers['Content-Type'] = contentType;
    }
    return encodeBodyUtf8 && postBody is String
        ? utf8.encode(postBody)
        : postBody;
  }

  Future<ApiCallResponse> call(
    ApiCallOptions options, {
    http.Client? client,
  }) =>
      makeApiCall(
        callName: options.callName,
        apiUrl: options.apiUrl,
        callType: options.callType,
        headers: options.headers,
        params: options.params,
        body: options.body,
        bodyType: options.bodyType,
        returnBody: options.returnBody,
        encodeBodyUtf8: options.encodeBodyUtf8,
        decodeUtf8: options.decodeUtf8,
        alwaysAllowBody: options.alwaysAllowBody,
        cache: options.cache,
        isStreamingApi: options.isStreamingApi,
        options: options,
        client: client,
      );

  Future<ApiCallResponse> makeApiCall({
    required String callName,
    required String apiUrl,
    required ApiCallType callType,
    Map<String, dynamic> headers = const {},
    Map<String, dynamic> params = const {},
    String? body,
    BodyType? bodyType,
    bool returnBody = true,
    bool encodeBodyUtf8 = false,
    bool decodeUtf8 = false,
    bool alwaysAllowBody = false,
    bool cache = false,
    bool isStreamingApi = false,
    ApiCallOptions? options,
    http.Client? client,
  }) async {
    final callOptions = options ??
        ApiCallOptions(
          callName: callName,
          callType: callType,
          apiUrl: apiUrl,
          headers: headers,
          params: params,
          bodyType: bodyType,
          body: body,
          returnBody: returnBody,
          encodeBodyUtf8: encodeBodyUtf8,
          decodeUtf8: decodeUtf8,
          alwaysAllowBody: alwaysAllowBody,
          cache: cache,
          isStreamingApi: isStreamingApi,
        );
    // Modify for your specific needs if this differs from your API.
    if (_accessToken != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $_accessToken';
    }
    if (!apiUrl.startsWith('http')) {
      apiUrl = 'https://$apiUrl';
    }

    // If we've already made this exact call before and caching is on,
    // return the cached result.
    if (cache && _apiCache.containsKey(callOptions)) {
      return _apiCache[callOptions]!;
    }

    ApiCallResponse result;
    try {
      switch (callType) {
        case ApiCallType.GET:
          result = await urlRequest(
            callType,
            apiUrl,
            headers,
            params,
            returnBody,
            decodeUtf8,
            isStreamingApi,
            client: client,
          );
          break;
        case ApiCallType.DELETE:
          result = alwaysAllowBody
              ? await requestWithBody(
                  callType,
                  apiUrl,
                  headers,
                  params,
                  body,
                  bodyType,
                  returnBody,
                  encodeBodyUtf8,
                  decodeUtf8,
                  alwaysAllowBody,
                  isStreamingApi,
                  client: client,
                )
              : await urlRequest(
                  callType,
                  apiUrl,
                  headers,
                  params,
                  returnBody,
                  decodeUtf8,
                  isStreamingApi,
                  client: client,
                );
          break;
        case ApiCallType.POST:
        case ApiCallType.PUT:
        case ApiCallType.PATCH:
          result = await requestWithBody(
            callType,
            apiUrl,
            headers,
            params,
            body,
            bodyType,
            returnBody,
            encodeBodyUtf8,
            decodeUtf8,
            alwaysAllowBody,
            isStreamingApi,
            client: client,
          );
          break;
      }

      // If caching is on, cache the result (if present).
      if (cache) {
        _apiCache[callOptions] = result;
      }
    } catch (e) {
      result = ApiCallResponse(null, {}, -1, exception: e);
    }

    return result;
  }
}
