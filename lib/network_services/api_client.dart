import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';
import 'package:maignanka_app/network_services/handle_response.dart';
import 'package:mime_type/mime_type.dart';
import 'api_urls.dart';
import 'logger.dart';

final log = logger(ApiClient);

abstract class ApiClient {
  static String bearerToken = '';
  static const int timeoutInSeconds = 60;

  /// +++++++++++ get request +++++++++++++
  static Future<HandleResponse> getRequest({required String url, Map<String, String>? headers}) async {
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };

    try {
      log.i('|📍📍📍|-----------------[[ GET ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url \n Headers: ${headers ?? mainHeaders}');

      final response = await get(
        Uri.parse(ApiUrls.baseUrl + url),
        headers: headers ?? mainHeaders,
      ).timeout(const Duration(seconds: timeoutInSeconds));

      return responseHandle(response);
    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ post request +++++++++++++
  static Future<HandleResponse> postRequest({required String url, required dynamic body, Map<String, String>? headers}) async {
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i('|📍📍📍|-----------------[[ POST ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url \n ${headers ?? mainHeaders} \n $body');

      final response = await post(
        Uri.parse(ApiUrls.baseUrl + url),
        headers: headers ?? mainHeaders,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return responseHandle(response);
    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ patch request +++++++++++++
  static Future<HandleResponse> patchRequest({required String url, required dynamic body, Map<String, String>? headers}) async {
    var mainHeaders = {
      //'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i('|📍📍📍|-----------------[[ PATCH ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url \n ${headers ?? mainHeaders} \n $body');

      final response = await patch(
        Uri.parse(ApiUrls.baseUrl + url),
        headers: headers ?? mainHeaders,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return responseHandle(response);
    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ put request +++++++++++++
  static Future<HandleResponse> putRequest({required String url, required dynamic body, Map<String, String>? headers}) async {
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i('|📍📍📍|-----------------[[ PUT ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url \n ${headers ?? mainHeaders} \n $body');

      final response = await put(
        Uri.parse(ApiUrls.baseUrl + url),
        headers: headers ?? mainHeaders,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return responseHandle(response);
    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ delete request +++++++++++++
  static Future<HandleResponse> deleteRequest({required String url, required dynamic body, Map<String, String>? headers}) async {
    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i('|📍📍📍|-----------------[[ DELETE ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url \n ${headers ?? mainHeaders} \n $body');

      final response = await delete(
        Uri.parse(ApiUrls.baseUrl + url),
        headers: headers ?? mainHeaders,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: timeoutInSeconds));
      return responseHandle(response);
    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ post Multipart request +++++++++++++
  static Future<HandleResponse> postMultipartRequest({required String url, required Map<dynamic, dynamic> body,required List<MultipartBody> multipartBody, Map<String, String>? headers}) async {
    var mainHeaders = {
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i('|📍📍📍|-----------------[[ POST MULTIPART ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url');
      log.i('Headers: ${headers ?? mainHeaders}');
      log.i('API Body: $body with ${multipartBody.length} files');
      final request = MultipartRequest('POST', Uri.parse(ApiUrls.baseUrl + url));

      request.headers.addAll(headers ?? mainHeaders);

      // Add form fields
      body.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add files
      for (MultipartBody element in multipartBody) {
        String? mimeType = mime(element.file.path);
        if (mimeType != null) {
          request.files.add(await MultipartFile.fromPath(
            element.key,
            element.file.path,
            contentType: MediaType.parse(mimeType),
          ));
        } else {
          log.e('MIME type not found for file: ${element.file.path}');
        }
      }

      // Send the request
      StreamedResponse response = await request.send();

      // Convert response to HTTP Response
      Response httpResponse = await Response.fromStream(response);

      return responseHandle(httpResponse);

    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ put Multipart Request +++++++++++++
  static Future<HandleResponse> putMultipartRequest(String url, Map<String, String> body, {List<MultipartBody>? multipartBody, List<MultipartListBody>? multipartListBody, Map<String, String>? headers,}) async {
    var mainHeaders = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i(
          '|📍📍📍|-----------------[[ PUT MULTIPART ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url');
      log.i('Headers: ${headers ?? mainHeaders}');
      log.i('API Body: $body with ${multipartBody?.length ?? 0} file(s)');


      final request = MultipartRequest('PUT', Uri.parse(ApiUrls.baseUrl + url));

      request.fields.addAll(body);


      // Add files
      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          log.i("File path: ${element.file.path}");
          if (element.file.existsSync()) {
            String? mimeType = mime(element.file.path);
            request.files.add(await MultipartFile.fromPath(
              element.key,
              element.file.path,
              contentType: MediaType.parse(mimeType!),
            ));
          } else {
            log.e("File does not exist: ${element.file.path}");
          }
        }
      }


      // Add headers to the request
      request.headers.addAll(mainHeaders);

      // Send the request and get the streamed response
      StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();

      log.i('====> API Response: [${response.statusCode}] $url');
      log.i(content);

      return responseHandle(json.decode(content));

    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// +++++++++++ patch Multipart Request +++++++++++++
  static Future<HandleResponse> patchMultipartRequest(String url, Map<String, String> body, {List<MultipartBody>? multipartBody, List<MultipartListBody>? multipartListBody, Map<String, String>? headers}) async {
    var mainHeaders = {
      'Authorization': 'Bearer $bearerToken',
    };
    try {
      log.i(
          '|📍📍📍|-----------------[[ PATCH MULTIPART ]] method details start -----------------|📍📍📍|');
      log.i('URL: $url');
      log.i('Headers: ${headers ?? mainHeaders}');
      log.i('API Body: $body with ${multipartBody?.length ?? 0} file(s)');

      var request =
      MultipartRequest('PATCH', Uri.parse(ApiUrls.baseUrl + url));
      request.fields.addAll(body);

      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          log.i("File path: ${element.file.path}");
          String? mimeType = mime(element.file.path);
          request.files.add(MultipartFile(
            element.key,
            element.file.readAsBytes().asStream(),
            element.file.lengthSync(),
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType!),
          ));
        }
      }
      request.headers.addAll(mainHeaders);
      StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      log.i('====> API Response: [${response.statusCode}] $url');
      log.i(content);

      return responseHandle(json.decode(content));

    } catch (e, s) {
      log.e('🐞🐞🐞 Error in getData: ${e.toString()}');
      log.e('Stacktrace: ${s.toString()}');
      return HandleResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }







  /// ===============> Response Handle <=====================
  static responseHandle(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return HandleResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: jsonDecode(response.body),
      );
    } else if (response.statusCode == 400) {
      return HandleResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Bad Request',
      );
    } else if (response.statusCode == 401) {
      return HandleResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Unauthorized',
      );
    } else if (response.statusCode == 404) {
      return HandleResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Not Found',
      );
    } else if (response.statusCode == 500 || response.statusCode == 502) {
      return HandleResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Internal Server Error',
      );
    } else {
      return HandleResponse(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: '',
      );
    }
  }
}


class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;
  MultipartListBody(this.key, this.value);
}
