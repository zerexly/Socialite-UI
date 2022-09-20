extension StringExtension on String {
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
