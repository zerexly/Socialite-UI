import 'dart:math';

import 'package:foap/helper/common_import.dart';

String randomId() {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      25, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

int messageTypeId(MessageContentType type) {
  switch (type) {
    case MessageContentType.text:
      return 1;
    case MessageContentType.photo:
      return 2;
    case MessageContentType.video:
      return 3;
    case MessageContentType.audio:
      return 4;
    case MessageContentType.gif:
      return 5;
    case MessageContentType.sticker:
      return 6;
    case MessageContentType.contact:
      return 7;
    case MessageContentType.location:
      return 8;
    case MessageContentType.reply:
      return 9;
    case MessageContentType.forward:
      return 10;
    case MessageContentType.post:
      return 11;
    case MessageContentType.story:
      return 12;
  }
}

int uploadMediaTypeId(UploadMediaType type) {
  switch (type) {
    case UploadMediaType.post:
      return 1;
    case UploadMediaType.storyOrHighlights:
      return 3;
    case UploadMediaType.chat:
      return 5;
  }
}
