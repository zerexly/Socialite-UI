import 'package:foap/util/app_config_constants.dart';

//////******* Do not make any change in this file **********/////////

class NetworkConstantsUtil {
  static String baseUrl = AppConfigConstants.restApiBaseUrl;
  static String login = 'users/login';
  static String socialLogin = 'users/login-social';
  static String forgotPassword = 'users/forgot-password-request';
  static String resetPassword = 'users/set-new-password';
  static String resendOTP = 'users/resend-otp';
  static String verifyRegistrationOTP = 'users/verify-registration-otp';
  static String verifyFwdPWDOTP = 'users/forgot-password-verify-otp';
  static String verifyChangePhoneOTP = 'users/verify-otp';

  static String updatedDeviceToken = 'users/update-token';

  static String getSuggestedUsers =
      'users/sugested-user?expand=isFollowing,isFollower,userLiveDetail';

  static String register = 'users/register';
  static String checkUserName = 'users/check-username';

  static String getCompetitions =
      'competitions?expand=competitionPosition,post,post.user';
  static String joinCompetition = 'competitions/join';
  static String getCompetitionDetail =
      'competitions/{{id}}?expand=post,post.user,competitionPosition.post.user,winnerPost';

  static String addPost = 'posts';
  static String uploadPostImage = 'posts/upload-gallary';
  static String uploadFileImage = 'file-uploads/upload-file';
  static String addCompetitionPost = 'posts/competition-image';
  static String searchPost =
      'posts/search-post?expand=user,user.userLiveDetail,clubDetail.createdByUser , clubDetail.totalJoinedUser';
  static String postDetail =
      'posts/{id}?expand=user,user.userLiveDetail,clubDetail,giftSummary';
  static String mentionedPosts =
      'posts/my-post-mention-user?expand=user&user_id=';
  static String likePost = 'posts/like';
  static String unlikePost = 'posts/unlike';

  static String getComments = 'posts/comment-list';
  static String addComment = 'posts/add-comment';
  static String reportPost = 'posts/report-post';
  static String deletePost = 'posts/{{id}}';

  static String otherUser =
      'users/{{id}}?expand=isFollowing,isFollower,totalFollowing,totalFollower,totalPost,totalWinnerPost,userLiveDetail,giftSummary';
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
      'users/profile?expand=totalFollowing,totalFollower,totalActivePost,userLiveDetail,giftSummary';
  static String updateUserProfile = 'users/profile-update';
  static String updateProfileImage = 'users/update-profile-image';
  static String updatePassword = 'users/update-password';
  static String updatePhone = 'users/update-mobile';
  static String updateLocation = 'users/update-location';

  static String getCountries = 'countries';
  static String reportUser = 'users/report-user';

  static String getPackages = 'packages';
  static String subscribePackage = 'payments/package-subscription';
  static String updatePaymentDetail = 'users/update-payment-detail';
  static String withdrawHistory = 'payments/withdrawal-history';
  static String withdrawalRequest = 'payments/withdrawal';
  static String redeemCoins = 'payments/redeem-coin';

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

  //******************** reel ******************//
  static String reelAudioCategories = 'categories/reel-audio';
  static String audios = 'audios?';

  //***********chat***********//
  static String createChatRoom = 'chats/create-room';
  static String updateGroupChatRoom = 'chats/update-room?id=';
  static String getChatRoomDetail =
      'chats/room-detail?room_id={room_id}&expand=createdByUser,chatRoomUser.user,chatRoomUser.user.userLiveDetail';
  static String getChatRooms =
      'chats/room?expand=createdByUser,chatRoomUser,chatRoomUser.user,lastMessage,chatRoomUser.user.userLiveDetail';
  static String deleteChatRoom = 'chats/delete-room?room_id=';
  static String deleteChatRoomMessages = 'chats/delete-room-chat';

  static String callHistory =
      'chats/call-history?expand=callerDetail,receiverDetail,receiverDetail.userLiveDetail';
  static String chatHistory =
      'chats/chat-message?expand=chatMessageUser,user&room_id={{room_id}}&last_message_id={{last_message_id}}';

  //***********live TVs***********//
  static String getTVCategories =
      'categories/live-tv?expand=liveTv,liveTv.currentViewer';
  static String getTVShows = 'live-tvs/tv-shows?expand=tvShowEpisode';

  static String getTVShowEpisodes = 'tv-shows/tv-show-episodes?';
  static String liveTvs = 'live-tvs?expand=currentViewer';
  static String tvBanners = 'tv-banners';
  static String subscribeLiveTv = 'live-tvs/subscribe';
  static String stopWatchingTv = 'live-tvs/stop-viewing';
  static String liveHistory = 'user-live-histories?expand=giftSummary';

  //***********Podcast***********//
  static String getPodcastCategories =
      'categories/podcast?expand=podcastList,podcastList.currentViewer';
  static String podcastBanners = 'podcast-banners';
  static String getHosts = 'podcasts?expand=currentViewer';
  static String getPodcastShows = 'podcast-shows?expand=podcastShow';
  static String getPodcastShowsEpisode = 'podcast-shows/podcast-show-episodes?';

  //***********Clubs***********//
  static String getClubCategories = 'clubs/category';
  static String createClub = 'clubs';
  static String updateClub = 'clubs/';
  static String deleteClub = 'clubs/';
  static String searchClubs = 'clubs?expand=createdByUser,totalJoinedUser';
  static String joinClub = 'clubs/join';
  static String leaveClub = 'clubs/left';
  static String removeUserFromClub = 'clubs/remove';
  static String clubMembers = 'clubs/club-joined-user?expand=user&id=';
  static String clubJoinInvites =
      'clubs/my-invitation?expand=club.totalJoinedUser';
  static String replyOnInvitation = 'clubs/invitation-reply';
  static String sendClubInvite = 'clubs/invite';

  static String sendClubJoinRequest = 'clubs/join-request';
  static String clubJoinRequestList =
      'clubs/join-request-list?club_id={{club_id}}&expand=user';
  static String clubJoinRequestReply = 'clubs/join-request-reply';

  //***********Events***********//
  static String joinEvent = 'clubs/join';
  static String leaveEvent = 'clubs/left';
  static String eventMembers = 'clubs/club-joined-user?expand=user&id=';

  static String eventsCategories = 'categories/event?expand=event';
  static String searchEvents = 'events?';
  static String eventCoupons = 'events/coupon';
  static String eventDetails =
      'events/{{id}}?expand=eventTicket,eventOrganisor';
  static String buyTicket = 'events/buy-ticket';
  static String eventBookings = 'events/my-booked-event?';
  static String cancelEventBooking = 'events/cancel-ticket-booking';

  static String giftTicket = 'events/gift-ticket';

  //***********random live and chat***********//
  static String randomLives = 'chats/live-user?expand=userLiveDetail';
  static String randomOnlineUser = 'chats/online-user';

  //***********gifts***********//
  static String giftsCategories = 'categories/gift?expand=gift';
  static String giftsByCategory = 'gifts?category_id=';
  static String mostUsedGifts = 'gifts/popular';
  static String sendGift = 'gifts/send-gift';
  static String giftsReceived =
      'gifts/recieved-gift?expand=giftDetail,senderDetail&send_on_type={{send_on_type}}&live_call_id={{live_call_id}}&post_id={{post_id}}';

  //***********verification***********//
  static String requestVerification = 'user-verifications';
  static String requestVerificationHistory = 'user-verifications';
  static String cancelVerification = 'user-verifications/cancel';

  //***********FAQ***********//
  static String getFAQs = 'faqs';

  //***********Payment***********//
  static String createPaymentIntent = 'payments/payment-intent';
  static String getPaypalClientToken = 'payments/paypal-client-token';
  static String submitPaypalPayment = 'payments/paypal-payment';
}
