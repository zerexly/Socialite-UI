import 'package:foap/util/app_config_constants.dart';

//////******* Do not make any change in this file **********/////////

class NetworkConstantsUtil {
  static String baseUrl = AppConfigConstants.restApiBaseUrl;
  static String login = 'users/login';
  static String socialLogin = 'users/login-social';
  static String forgotPassword = 'users/forgot-password-request';
  static String resetPassword = 'users/set-new-password';
  static String resendOTP = 'users/resend-otp';

  static String updatedDeviceToken = 'users/update-token';

  static String getSuggestedUsers =
      'users/sugested-user?expand=isFollowing,isFollower,userLiveDetail';

  static String verifyRegistrationOTP = 'users/verify-registration-otp';
  static String verifyFwdPWDOTP = 'users/forgot-password-verify-otp';
  static String verifyChangePhoneOTP = 'users/verify-otp';

  static String register = 'users/register';
  static String checkUserName = 'users/check-username';

  static String getCompetitions =
      'competitions?expand=competitionPosition,post,post.user';
  static String joinCompetition = 'competitions/join';
  static String getCompetitionDetail =
      'competitions/{{id}}?expand=post,post.user,competitionPosition.post.user';

  static String addPost = 'posts';
  static String uploadPostImage = 'posts/upload-gallary';
  static String uploadFileImage = 'file-uploads/upload-file';
  static String addCompetitionPost = 'posts/competition-image';
  static String searchPost =
      'posts/search-post?expand=user,user.userLiveDetail';
  static String postDetail = 'posts/{id}?expand=user,user.userLiveDetail';
  static String mentionedPosts =
      'posts/my-post-mention-user?expand=user&user_id=';
  static String likePost = 'posts/like';
  static String unlikePost = 'posts/unlike';

  static String getComments = 'posts/comment-list';
  static String addComment = 'posts/add-comment';
  static String reportPost = 'posts/report-post';

  static String otherUser = 'users/';
  static String followUser = 'followers';
  static String unfollowUser = 'followers/unfollow';
  static String followMultipleUser = 'followers/follow-multiple';

  static String followers =
      'followers/my-follower?expand=followerUserDetail,followerUserDetail.isFollowing,followerUserDetail.isFollower&user_id=';
  static String following =
      'followers/my-following?expand=followingUserDetail,followingUserDetail.isFollowing,followerUserDetail.isFollower&user_id=';

  static String stories = 'stories?expand=user,user.userLiveDetail';
  static String addStory = 'stories';

  static String findFriends =
      'users/find-friend?expand=isFollowing,isFollower&';
  static String searchHashtag = 'posts/hash-counter-list?hashtag=';

  static String searchUsers =
      'users/search-user?expand=isFollowing,userLiveDetail';
  static String getMyProfile =
      'users/profile?expand=following.followingUserDetail,follower.followerUserDetail,totalActivePost,userLiveDetail';
  static String updateUserProfile = 'users/profile-update';
  static String updateProfileImage = 'users/update-profile-image';
  static String updatePassword = 'users/update-password';
  static String updatePhone = 'users/update-mobile';

  static String getCountries = 'countries';
  static String reportUser = 'users/report-user';

  static String getPackages = 'packages';
  static String subscribePackage = 'payments/package-subscription';
  static String updatePaymentDetail = 'users/update-payment-detail';
  static String withdrawHistory = 'payments/withdrawal-history';
  static String withdrawalRequest = 'payments/withdrawal';

  static String rewardedAdCoins = 'posts/promotion-ad-view';
  static String getNotifications = 'notifications';

  static String submitRequest = 'support-requests';
  static String supportRequests = 'support-requests?is_reply=';

  static String notificationSettings = 'users/push-notification-status';

  static String myStories = 'stories/my-story';
  static String myCurrentActiveStories =
      'stories/my-active-story?expand=userStory';
  static String deleteStory = 'stories/';
  static String currentLiveUsers =
      'followers/my-following-live?expand=followingUserDetail,followingUserDetail.isFollowing,,followingUserDetail.isFollower,followingUserDetail.userLiveDetail&user_id=';

  static String highlights =
      'highlights?expand=highlightStory,highlightStory.story.user&user_id=';
  static String addHighlight = 'highlights';
  static String updateHighlight = 'highlights/';
  static String deleteHighlight = 'highlights';
  static String addStoryToHighlight = 'highlights/add-story';
  static String removeStoryFromHighlight = 'highlights/remove-story';

  static String getSettings = 'settings';

  static String blockUser = 'blocked-users';
  static String blockedUsers =
      'blocked-users?expand=blockedUserDetail,userLiveDetail';
  static String unBlockUser = 'blocked-users/un-blocked';

  static String deleteAccount = 'users/delete-account';

  ///////////// chat
  static String createChatRoom = 'chats/create-room';
  static String getRooms =
      'chats/room?expand=chatRoomUser,chatRoomUser.user,lastMessage,chatRoomUser.user.userLiveDetail';
  static String deleteChatRoom = 'chats/delete-room?room_id=';

  static String callHistory =
      'chats/call-history?expand=callerDetail,receiverDetail,receiverDetail.userLiveDetail';
}