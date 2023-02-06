import 'package:foap/helper/common_import.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostModel {
  int id = 0;
  String title = '';

  late UserModel user;
  int? competitionId = 0;

  int totalView = 0;
  int totalLike = 0;
  int totalComment = 0;
  int totalShare = 0;
  int isWinning = 0;
  bool isLike = false;
  bool isReported = false;

  List<PostGallery> gallery = [];
  List<String> tags = [];
  List<MentionedUsers> mentionedUsers = [];

  ReelMusicModel? audio;
  ClubModel? club;

  String postTime = '';
  DateTime? createDate;

  PostModel();

  // bool isVideoPost(){
  //   return gallery.first.mediaType == 2;
  // }

  factory PostModel.fromJson(dynamic json) {
    PostModel model = PostModel();
    model.id = json['id'];
    model.title = json['title'] ?? 'No title';

    model.user = UserModel.fromJson(json['user']);
    model.competitionId = json['competition_id'];
    model.totalView = json['total_view'] ?? 0;
    model.totalLike = json['total_like'] ?? 0;
    model.totalComment = json['total_comment'] ?? 0;
    model.totalShare = json['total_share'] ?? 0;
    model.isWinning = json['is_winning'] ?? 0;

    model.isLike = json['is_like'] == 1;
    model.isReported = json['is_reported'] == 1;

    // model.imageUrl = json['imageUrl'];
    model.tags = [];
    if (json['hashtags'] != null && json['hashtags'].length > 0) {
      model.tags = List<String>.from(json['hashtags'].map((x) => '#$x'));
    }

    if (json['postGallary'] != null && json['postGallary'].length > 0) {
      model.gallery = List<PostGallery>.from(
          json['postGallary'].map((x) => PostGallery.fromJson(x)));
    }

    if (json['mentionUsers'] != null && json['mentionUsers'].length > 0) {
      model.mentionedUsers = List<MentionedUsers>.from(
          json['mentionUsers'].map((x) => MentionedUsers.fromJson(x)));
    }

    model.createDate =
        DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toUtc();

    model.postTime = timeago.format(model.createDate!);
    model.audio =
    json['audio'] == null ? null : ReelMusicModel.fromJson(json['audio']);
    model.club = json['clubDetail'] == null
        ? null
        : ClubModel.fromJson(json['clubDetail']);
    // final days = model.createDate!.difference(DateTime.now()).inDays;
    // if (days == 0) {
    //   model.postTime = ApplicationLocalizations.of(
    //           NavigationService.instance.getCurrentStateContext())
    //       .translate('today_text');
    // } else if (days == 1) {
    //   model.postTime = ApplicationLocalizations.of(
    //           NavigationService.instance.getCurrentStateContext())
    //       .translate('yesterday_text');
    // } else {
    //   String dateString = DateFormat('MMM dd, yyyy').format(model.createDate!);
    //   String timeString = DateFormat('hh:ss a').format(model.createDate!);
    //   model.postTime =
    //       '$dateString ${ApplicationLocalizations.of(NavigationService.instance.getCurrentStateContext()).translate('at_text')} $timeString';
    // }
    return model;
  }

  bool get containVideoPost {
    return gallery.where((element) => element.isVideoPost).isNotEmpty;
  }

  bool get isMyPost {
    return user.id == getIt<UserProfileManager>().user!.id;
  }
}

class MentionedUsers {
  int id = 0;
  String userName = '';

  MentionedUsers();

  factory MentionedUsers.fromJson(dynamic json) {
    MentionedUsers model = MentionedUsers();
    model.id = json['user_id'];
    model.userName = json['username'].toString().toLowerCase();
    return model;
  }
}
