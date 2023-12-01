class HttpException implements Exception {
  final String message;
  var statusCode;

  HttpException(this.message, [this.statusCode]);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
