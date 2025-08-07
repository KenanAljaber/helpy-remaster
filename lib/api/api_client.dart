import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:helpy/utils/config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late http.Client _client;
  Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Initialize the API client
  void initialize() {
    _client = http.Client();
  }

  // Dispose the client when done
  void dispose() {
    _client.close();
  }

  // Set default headers
  void setDefaultHeaders(Map<String, String> headers) {
    _defaultHeaders.addAll(headers);
  }

  // Add authorization token
  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  // Remove authorization token
  void removeAuthToken() {
    _defaultHeaders.remove('Authorization');
  }

  // Helper method to merge headers
  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  // Helper method to handle response
  ApiResponse _handleResponse(http.Response response) {
    try {
      final body = response.body.isNotEmpty ? json.decode(response.body) : null;

      return ApiResponse(
        statusCode: response.statusCode,
        data: body,
        headers: response.headers,
        isSuccess: response.statusCode >= 200 && response.statusCode < 300,
      );
    } catch (e) {
      return ApiResponse(
        statusCode: response.statusCode,
        data: response.body,
        headers: response.headers,
        isSuccess: false,
        error: 'Failed to parse response: $e',
      );
    }
  }

  // Helper method to handle exceptions
  ApiResponse _handleException(dynamic error) {
    String errorMessage = 'An unexpected error occurred';

    if (error is SocketException) {
      errorMessage = 'No internet connection';
    } else if (error is HttpException) {
      errorMessage = 'HTTP error occurred';
    } else if (error is FormatException) {
      errorMessage = 'Invalid response format';
    } else if (error is Exception) {
      errorMessage = error.toString();
    }

    return ApiResponse(
      statusCode: 0,
      data: null,
      headers: {},
      isSuccess: false,
      error: errorMessage,
    );
  }

  // GET request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.get(
        uri,
        headers: _mergeHeaders(headers),
      );

      return _handleResponse(response);
    } catch (error) {
      return _handleException(error);
    }
  }

  // POST request
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.post(
        uri,
        headers: _mergeHeaders(headers),
        body: body is String ? body : json.encode(body),
      );

      return _handleResponse(response);
    } catch (error) {
      return _handleException(error);
    }
  }

  // PUT request
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.put(
        uri,
        headers: _mergeHeaders(headers),
        body: body is String ? body : json.encode(body),
      );

      return _handleResponse(response);
    } catch (error) {
      return _handleException(error);
    }
  }

  // PATCH request
  Future<ApiResponse> patch(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.patch(
        uri,
        headers: _mergeHeaders(headers),
        body: body is String ? body : json.encode(body),
      );

      return _handleResponse(response);
    } catch (error) {
      return _handleException(error);
    }
  }

  // DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client.delete(
        uri,
        headers: _mergeHeaders(headers),
        body: body is String ? body : json.encode(body),
      );

      return _handleResponse(response);
    } catch (error) {
      return _handleException(error);
    }
  }

  // Upload file (multipart/form-data)
  Future<ApiResponse> uploadFile(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      final mergedHeaders = _mergeHeaders(headers);
      request.headers.addAll(mergedHeaders);

      // Add fields
      request.fields.addAll(fields);

      // Add files
      for (final entry in files.entries) {
        final stream = http.ByteStream(entry.value.openRead());
        final length = await entry.value.length();
        final multipartFile = http.MultipartFile(
          entry.key,
          stream,
          length,
          filename: entry.value.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (error) {
      return _handleException(error);
    }
  }

  // Helper method to build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final baseUrl = endpoint.startsWith('http')
        ? endpoint
        : '${Config.apiBaseUrl}/$endpoint';
    final uri = Uri.parse(baseUrl);

    if (queryParameters != null && queryParameters.isNotEmpty) {
      final queryMap = <String, String>{};
      queryParameters.forEach((key, value) {
        if (value != null) {
          queryMap[key] = value.toString();
        }
      });
      return uri.replace(queryParameters: queryMap);
    }

    return uri;
  }

  // Helper method to log requests (for debugging)
  void _logRequest(String method, String url, {dynamic body}) {
    if (kDebugMode) {
      print('🌐 API Request: $method $url');
      if (body != null) {
        print('📦 Request Body: ${json.encode(body)}');
      }
    }
  }

  // Helper method to log responses (for debugging)
  void _logResponse(String method, String url, ApiResponse response) {
    if (kDebugMode) {
      print('📡 API Response: $method $url');
      print('📊 Status Code: ${response.statusCode}');
      print('📦 Response Data: ${json.encode(response.data)}');
      if (response.error != null) {
        print('❌ Error: ${response.error}');
      }
    }
  }
}

// API Response class
class ApiResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;
  final bool isSuccess;
  final String? error;

  ApiResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
    required this.isSuccess,
    this.error,
  });

  // Helper methods for common response patterns
  bool get isOk => isSuccess && statusCode == 200;
  bool get isCreated => isSuccess && statusCode == 201;
  bool get isNoContent => statusCode == 204;
  bool get isBadRequest => statusCode == 400;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode >= 500;

  // Helper method to get data as specific type
  T? getData<T>() {
    if (data is T) {
      return data as T;
    }
    return null;
  }

  // Helper method to get nested data
  dynamic getNestedData(List<String> keys) {
    dynamic current = data;
    for (final key in keys) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  @override
  String toString() {
    return 'ApiResponse(statusCode: $statusCode, isSuccess: $isSuccess, error: $error, data: $data)';
  }
}

// API Exception class
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode)';
  }
}
