import 'package:http/http.dart';

String httpErrorToMessage(Response response) {
  final statusCode = response.statusCode;
  final reason =
      response.reasonPhrase == null || response.reasonPhrase!.isNotEmpty
          ? response.reasonPhrase
          : 'not specified';

  return 'Request failed\nStatus Code: $statusCode\nReason: $reason';
}
