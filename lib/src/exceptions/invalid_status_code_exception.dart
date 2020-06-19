import 'itelligence_exception.dart';

/// Thrown if the [statusCode] != 200
class InvalidStatusCodeException extends ItelligenceException {
  /// The http status code of the request
  final int statusCode;
  /// The response body
  final String body;
  /// The reason from the response
  final String reason;

  ///
  InvalidStatusCodeException(this.statusCode, this.body, this.reason);

  @override
  String toString() => 'InvalidStatusCodeException:'
      ' Server returned status code $statusCode:$reason';
}
