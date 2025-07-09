import 'package:userx_flutter/userx_flutter.dart';

const String USERX_KEY = '0d2a4337-f63a-4d17-9bea-fa1ecc198a4b';

void initUserX() {
  UserX.start(USERX_KEY);
  UserX.setCatchExceptions(true);
}
