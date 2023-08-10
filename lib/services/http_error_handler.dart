import 'package:http/http.dart' as http;

String httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final String errMsg =
      'Запрос не выполнен\nСтатус: $statusCode\nПричина: $reasonPhrase';

  return errMsg;
}