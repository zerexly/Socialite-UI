class PostSearchQuery {
  int? userId;
  int? isPopular = 0;
  int? isFollowing = 0;
  int? isSold = 0;
  int? isMine = 0;
  int? isRecent = 0;
  String? title = '';
  String? hashTag = '';

  String uniqueId() {
    return '${userId}_${isPopular}_${isFollowing}_${isSold}_${isMine}_${isRecent}_${title}_$hashTag';
  }

  @override
  bool operator ==(other) {
    return (other is PostSearchQuery) &&
        other.userId == userId &&
        other.isPopular == isPopular &&
        other.isFollowing == isFollowing &&
        other.isSold == isSold &&
        other.isMine == isMine &&
        other.isRecent == isRecent &&
        other.title == title &&
        other.hashTag == hashTag;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;




}

class MentionedPostSearchQuery {
  int userId;

  MentionedPostSearchQuery({required this.userId});
}
