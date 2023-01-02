import 'common_import.dart';

extension StringExtension on String {
  bool get isValidUrl {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (isEmpty) {
      return false;
    } else if (!regExp.hasMatch(this)) {
      return false;
    }
    return true;
  }

  List<String> getHashtags() {
    List<String> hashtags = [];
    RegExp exp = RegExp(r"\B#\w\w+");
    exp.allMatches(this).forEach((match) {
      if (match.group(0) != null) {
        hashtags.add(match.group(0)!.replaceAll("#", ""));
      }
    });
    return hashtags;
  }

  List<String> getMentions() {
    List<String> mentions = [];
    RegExp exp = RegExp(r"\B@\w\w+");
    exp.allMatches(this).forEach((match) {
      if (match.group(0) != null) {
        mentions.add(match.group(0)!.replaceAll("@", ""));
      }
    });
    return mentions;
  }

  String encrypted() {
    // final encryptionKey =
    //     encrypt.Key.fromUtf8(AppConfigConstants.encryptionKey);
    //
    // final iv = encrypt.IV.fromLength(16);
    //
    // final encrypter = encrypt.Encrypter(
    //     encrypt.AES(encryptionKey, mode: encrypt.AESMode.ecb));
    //
    // final encryptedMessageContent = encrypter.encrypt(this, iv: iv);
    //
    // return encryptedMessageContent.base64;
    if (isEmpty) {
      return '';
    }
    if (AppConfigConstants.enableEncryption == 1) {
      return encryptAESCryptoJS(this, AppConfigConstants.encryptionKey);
    } else {
      return this;
    }
  }

  String decrypted() {
    // final encryptionKey =
    //     encrypt.Key.fromUtf8(AppConfigConstants.encryptionKey);
    //
    // final iv = encrypt.IV.fromLength(16);
    //
    // final encrypter = encrypt.Encrypter(
    //     encrypt.AES(encryptionKey, mode: encrypt.AESMode.ecb));
    //
    // final decrypted = encrypter.decrypt64(this, iv: iv);
    // return decrypted.replaceAll('\\', '');
    if (isEmpty) {
      return '';
    }
    try {
      return decryptAESCryptoJS(this, AppConfigConstants.encryptionKey);
    } catch (error) {
      return this;
    }
  }
}
