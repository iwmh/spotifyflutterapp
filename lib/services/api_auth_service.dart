import 'package:flutter/cupertino.dart';
import 'package:spotifyflutterapp/data/repositories/base_api_auth_repository.dart';

class ApiAuthService {

  final BaseApiAuthRepository apiAuthRepository;

  // require its repo for api auth.
  ApiAuthService({Key key, @required this.apiAuthRepository});
}