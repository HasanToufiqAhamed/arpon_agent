import 'package:onesignal_flutter/onesignal_flutter.dart';

sendNotification(List<String> tokenIdList, String body, String heading) async {

  OneSignal.shared.postNotification(
    OSCreateNotification(
      playerIds: tokenIdList,
      content: body,
      heading: heading,
    ),
  );
}