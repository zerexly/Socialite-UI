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
}
