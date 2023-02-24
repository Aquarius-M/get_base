import 'package:get_base/get_base.dart';

class Repository extends BaseRepository {
  final RepositoryConfig _config = RepositoryConfig(
    baseUrl: "https://softcdn.pintreel.com",
    useLog: true,
  );

  @override
  RepositoryConfig config() {
    return _config;
  }

  @override
  Map<String, dynamic> getHeader() {
    return {'api-request-source': "crm",};
  }

  @override
  HttpTransformer getTransformer() {
    return DefaultHttpTransformer.getInstance();
  }

  Future pwdLogin() async {
    await post(
      url: "/api/user/login",
      data: {
        "account": "shi",
        // "password": "123456szx",
      },
      onSuccess: (data) {},
      onFail: (code, msg) {},
      showTip: true,
      showErrorTip: true,
    );
  }
}
