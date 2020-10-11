import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/data/cases/services/auth-service.dart';

import 'package:chat_mobile/flavors/globals.dart' as globals;

class MobileApiClient extends ApiClient {
  MobileApiClient()
      : super(Uri.parse(globals.chatApiAddress),
            onBeforeRequest: (ApiRequest request) async {
          if (authService.authCode.isNotEmpty)
            return request.change(
                headers: {}
                  ..addAll(request.headers)
                  ..addAll({'authorization': authService.authCode}));
          return request;
        }, onAfterResponse: (ApiResponse response) async {
          if (response.headers.containsKey('authorization'))
            await authService.updateCode(response.headers['authorization']);
          return response;
        });
}
