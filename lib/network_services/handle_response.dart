class HandleResponse {
  final bool isSuccess;
  final int statusCode;
  String errorMessage;
  dynamic responseData;

  HandleResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage = 'Something went wrong',
  });
}
