import 'package:asesmen_kidk_rumah_sakit/helpers/user_info.dart';

class LogoutBloc {
  static Future logout() async {
    await UserInfo().logout();
  }
}
