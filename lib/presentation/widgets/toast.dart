import 'package:fluttertoast/fluttertoast.dart';

import '../../config/keys.dart';

Future<bool?> featureNotImplementedToast() {
  return toast( featureNotImplementedMessage);
}

Future<bool?> toast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 16.0,
  );
}
