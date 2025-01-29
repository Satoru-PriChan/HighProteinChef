import 'package:http/http.dart';

extension ResponseEx on Response {
  String get debugDescription => "status code: ${statusCode}, base request: ${request?.url.toString() ?? "NULL"}, body: ${body}";
}