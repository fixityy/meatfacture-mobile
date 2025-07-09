import 'package:userx_flutter/userx_flutter.dart';

const String USERX_KEY = '433c2016-65f9-46a3-8c78-3b1d8fac511c';

void initUserX() {
  UserX.start(USERX_KEY);
  UserX.setCatchExceptions(true);
}
