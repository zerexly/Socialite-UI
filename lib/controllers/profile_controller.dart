import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final PostController postController = Get.find<PostController>();
  final ChatDetailController chatDetailController = Get.find();

  Rx<UserModel> user = UserModel().obs;
  RxBool userNameCheckStatus = false.obs;
  RxBool isLoading = true.obs;

  RxList<UserModel> followers = <UserModel>[].obs;
  RxList<UserModel> following = <UserModel>[].obs;

  RxList<UserModel> processingActionUsers = <UserModel>[].obs;
  RxList<UserModel> completedActionUsers = <UserModel>[].obs;
  RxList<UserModel> failedActionUsers = <UserModel>[].obs;

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxList<PaymentModel> payments = <PaymentModel>[].obs;
  RxInt selectedSegment = 0.obs;

  RxBool noDataFound = false.obs;

  int followersPage = 1;
  bool canLoadMoreFollowers = true;
  bool followersIsLoading = false;

  int followingPage = 1;
  bool canLoadMoreFollowing = true;
  bool followingIsLoading = false;

  bool isLoadingPosts = false;
  int postsCurrentPage = 1;
  bool canLoadMorePosts = true;


  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<PostModel> mentions = <PostModel>[].obs;

  int mentionsPostPage = 1;
  bool canLoadMoreMentionsPosts = true;
  bool mentionsPostsIsLoading = false;

  PostSearchQuery? postSearchQuery;
  MentionedPostSearchQuery? mentionedPostSearchQuery;

  clear() {
    followersPage = 1;
    canLoadMoreFollowers = true;
    followersIsLoading = false;

    followingPage = 1;
    canLoadMoreFollowing = true;
    followingIsLoading = false;

    selectedSegment.value = 0;

    isLoadingPosts = false;
    postsCurrentPage = 1;
    canLoadMorePosts = true;

    mentionsPostPage = 1;
    canLoadMoreMentionsPosts = true;
    mentionsPostsIsLoading = false;

    posts.value = [];
    mentions.value = [];

    processingActionUsers.clear();
    failedActionUsers.clear();
    completedActionUsers.clear();
  }

  updateActionForUser(UserModel user, int action) {
    if (action == 0) {
      failedActionUsers.add(user);
    }
    if (action == 1) {
      processingActionUsers.add(user);
      failedActionUsers.remove(user);
    }
    if (action == 2) {
      completedActionUsers.add(user);
      processingActionUsers.remove(user);
      failedActionUsers.remove(user);
    }
  }

  sendMessage({required UserModel toUser, PostModel? post}) {
    updateActionForUser(toUser, 1);
    if (post != null) {
      chatDetailController
          .sendPostAsMessage(post: post, toOpponent: toUser)
          .then((status) {
        if (status == true) {
          updateActionForUser(toUser, 2);
        } else {
          updateActionForUser(toUser, 0);
        }
        update();
      });
    } else {
      chatDetailController.forwardSelectedMessages(toUser).then((status) {
        if (status == true) {
          updateActionForUser(toUser, 2);
        } else {
          updateActionForUser(toUser, 0);
        }
        update();
      });
    }
  }

  getUserProfile() {
    user.value = getIt<UserProfileManager>().user!;
    update();
    ApiController().getMyProfile().then((value) {
      user.value = value.user!;
      update();
    });
  }

  setUser(UserModel userObj) {
    user.value = userObj;
    update();
  }

  segmentChanged(int index) {
    selectedSegment.value = index;
    postController.update();
    update();
  }

  getFollowers() {
    if (canLoadMoreFollowers) {
      followersIsLoading = true;
      ApiController().getFollowerUsers(page: followersPage).then((response) {
        followersIsLoading = false;
        followers.value = response.users;

        if (response.posts.length == response.metaData?.perPage) {
          followersPage += 1;
          canLoadMoreFollowers = true;
        } else {
          canLoadMoreFollowers = false;
        }
        update();
      });
    }
  }

  getFollowingUsers() {
    if (canLoadMoreFollowing) {
      followingIsLoading = true;
      ApiController().getFollowingUsers(page: followingPage).then((response) {
        followingIsLoading = false;
        following.value = response.users;

        if (response.posts.length == response.metaData?.perPage) {
          followingPage += 1;
          canLoadMoreFollowing = true;
        } else {
          canLoadMoreFollowing = false;
        }
        update();
      });
    }
  }

  void updateLocation(
      {required String country,
      required String city,
      required BuildContext context}) {
    if (FormValidator().isTextEmpty(country)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterCountry,
          isSuccess: false);
    } else if (FormValidator().isTextEmpty(city)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterCity,
          isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          getIt<UserProfileManager>().user!.country = country;
          getIt<UserProfileManager>().user!.city = city;

          ApiController()
              .updateUserProfile(getIt<UserProfileManager>().user!)
              .then((response) {
            if (response.success == true) {
              EasyLoading.dismiss();
              AppUtil.showToast(
                  context: context,
                  message: LocalizationString.profileUpdated,
                  isSuccess: true);
              getIt<UserProfileManager>().refreshProfile();

              user.value.country = country;
              user.value.city = city;
              update();
              Future.delayed(const Duration(milliseconds: 1200), () {
                Get.back();
              });
            } else {
              AppUtil.showToast(
                  context: context,
                  message: response.message,
                  isSuccess: false);
            }
          });
        }
      });
    }
  }

  void resetPassword(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword,
      required BuildContext context}) {
    if (FormValidator().isTextEmpty(oldPassword)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.enterOldPassword,
          isSuccess: false);
    } else if (FormValidator().isTextEmpty(newPassword)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.enterNewPassword,
          isSuccess: false);
    } else if (FormValidator().isTextEmpty(confirmPassword)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.enterConfirmPassword,
          isSuccess: false);
    } else if (newPassword != confirmPassword) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.passwordsDoesNotMatched,
          isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController()
              .changePassword(oldPassword, newPassword)
              .then((response) async {
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: true);
            if (response.success) {
              getIt<UserProfileManager>().refreshProfile();
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.to(() => const LoginScreen());
              });
            }
          });
        } else {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.noInternet,
              isSuccess: false);
        }
      });
    }
  }

  updatePaypalId({required String paypalId, required BuildContext context}) {
    if (FormValidator().isTextEmpty(paypalId)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterPaypalId,
          isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController().updatePaymentDetails(paypalId).then((response) {
            if (response.success == true) {
              EasyLoading.dismiss();
              AppUtil.showToast(
                  context: context,
                  message: LocalizationString.paymentDetailUpdated,
                  isSuccess: true);
              getIt<UserProfileManager>().refreshProfile();

              Future.delayed(const Duration(milliseconds: 1200), () {
                Get.back();
              });
            } else {
              AppUtil.showToast(
                  context: context,
                  message: response.message,
                  isSuccess: false);
            }
          });
        }
      });
    }
  }

  void updateMobile(
      {required String countryCode,
      required String phoneNumber,
      required BuildContext context}) {
    if (FormValidator().isTextEmpty(phoneNumber)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.enterPhoneNumber,
          isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController()
              .changePhone(countryCode, phoneNumber)
              .then((response) async {
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: true);
            if (response.success) {
              getIt<UserProfileManager>().refreshProfile();
              Get.to(() => VerifyOTPPhoneNumberChange(
                    token: response.token!,
                  ));
            }
          });
        } else {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.noInternet,
              isSuccess: false);
        }
      });
    }
  }

  updateUserName({required String userName, required BuildContext context}) {
    if (FormValidator().isTextEmpty(userName)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterUserName,
          isSuccess: false);
    } else if (userNameCheckStatus.value == false) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterValidUserName,
          isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController().updateUserName(userName).then((response) {
            if (response.success == true) {
              EasyLoading.dismiss();
              AppUtil.showToast(
                  context: context,
                  message: LocalizationString.userNameIsUpdated,
                  isSuccess: true);
              getUserProfile();
              Future.delayed(const Duration(milliseconds: 1200), () {
                Get.back();
              });
            } else {
              EasyLoading.dismiss();
              AppUtil.showToast(
                  context: context,
                  message: response.message,
                  isSuccess: false);
            }
          });
        }
      });
    }
  }

  void verifyUsername({required String userName}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        ApiController().checkUsername(userName).then((response) async {
          if (response.success) {
            userNameCheckStatus.value = true;
          } else {
            userNameCheckStatus.value = false;
          }
          update();
        });
      } else {
        userNameCheckStatus.value = false;
      }
    });
  }

  void editProfileImageAction(XFile pickedFile, BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().updateProfileImage(pickedFile).then((response) async {
          EasyLoading.dismiss();
          // AppUtil.showToast(
          //     context: context, message: response.message, isSuccess: true);
          getIt<UserProfileManager>().refreshProfile();
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

  updateBioMetricSetting(bool value, BuildContext context) {
    user.value.isBioMetricLoginEnabled = value == true ? 1 : 0;
    SharedPrefs().setBioMetricAuthStatus(value);

    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController()
            .updateBiometricSetting(user.value.isBioMetricLoginEnabled ?? 0)
            .then((response) {
          if (response.success == true) {
            getIt<UserProfileManager>().refreshProfile();
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context,
                message: LocalizationString.profileUpdated,
                isSuccess: true);
          } else {
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: false);
          }
        });
      }
    });
  }

  //////////////********** other user profile **************/////////////////

  void getOtherUserDetail(
      {required int userId, required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        ApiController().getOtherUser(userId.toString()).then((response) async {
          if (response.success) {
            user.value = response.user!;
            update();
          } else {
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: false);
          }
        });
      }
    });
  }

  void followUnFollowUserApi(
      {required int isFollowing, required BuildContext context}) {
    user.value.isFollowing = isFollowing;
    update();
    AppUtil.checkInternet().then((value) {
      if (value) {
        ApiController()
            .followUnFollowUser(isFollowing == 1, user.value.id)
            .then((response) async {
          if (response.success) {
            update();
          } else {
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: false);
          }
        });
      }
    });
  }

  void reportUser(BuildContext context) {
    user.value.isReported = true;
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().reportUser(user.value.id).then((response) async {
          EasyLoading.dismiss();
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

  void blockUser(BuildContext context) {
    user.value.isReported = true;
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().blockUser(user.value.id).then((response) async {
          EasyLoading.dismiss();
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

//////////////********** other user profile **************/////////////////

//////////////********** Notifications **************/////////////////

  getNotifications() {
    ApiController().getNotifications().then((response) {
      if (response.success == true) {
        notifications.value = response.notifications;
        update();
      }
    });
  }

  void withdrawalRequest(BuildContext context) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().performWithdrawalRequest().then((response) async {
          EasyLoading.dismiss();
          AppUtil.showToast(
              context: context, message: response.message, isSuccess: true);
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

  void getWithdrawHistory() {
    AppUtil.checkInternet().then((value) {
      if (value) {
        ApiController().getWithdrawHistory().then((response) async {
          if (response.success) {
            payments.value = response.payments;
            update();
          }
        });
      }
    });
  }

  followUser(UserModel user) {
    user.isFollowing = 1;
    if (following.where((e) => e.id == user.id).isNotEmpty) {
      following[following.indexWhere((element) => element.id == user.id)] =
          user;
    }
    if (followers.where((e) => e.id == user.id).isNotEmpty) {
      followers[followers.indexWhere((element) => element.id == user.id)] =
          user;
    }
    update();
    ApiController().followUnFollowUser(true, user.id).then((value) {});
  }

  unFollowUser(UserModel user) {
    user.isFollowing = 0;
    if (following.where((e) => e.id == user.id).isNotEmpty) {
      following[following.indexWhere((element) => element.id == user.id)] =
          user;
    }
    if (followers.where((e) => e.id == user.id).isNotEmpty) {
      followers[followers.indexWhere((element) => element.id == user.id)] =
          user;
    }
    update();
    ApiController().followUnFollowUser(false, user.id).then((value) {});
  }

  //******************** Posts ****************//

  setPostSearchQuery(PostSearchQuery query) {
    if (query != postSearchQuery) {
      clear();
    }
    update();
    postSearchQuery = query;
    getPosts();
  }

  setMentionedPostSearchQuery(MentionedPostSearchQuery query) {
    mentionedPostSearchQuery = query;
    getMyMentions();
  }

  void getPosts() async {
    if (canLoadMorePosts == true) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingPosts = true;
          ApiController()
              .getPosts(
              userId: postSearchQuery!.userId,
              isPopular: postSearchQuery!.isPopular,
              isFollowing: postSearchQuery!.isFollowing,
              isSold: postSearchQuery!.isSold,
              isMine: postSearchQuery!.isMine,
              isRecent: postSearchQuery!.isRecent,
              title: postSearchQuery!.title,
              hashtag: postSearchQuery!.hashTag,
              page: postsCurrentPage)
              .then((response) async {
            // posts.value = [];
            posts.addAll(response.success
                ? response.posts
                .where((element) => element.gallery.isNotEmpty)
                .toList()
                : []);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingPosts = false;

            if (response.posts.length == response.metaData?.perPage) {
              postsCurrentPage += 1;
              canLoadMorePosts = true;
            } else {
              canLoadMorePosts = false;
            }
            update();
          });
        }
      });
    }
  }

  void getMyMentions() {
    if (canLoadMoreMentionsPosts) {
      AppUtil.checkInternet().then((value) {
        if (value) {
          mentionsPostsIsLoading = true;
          ApiController()
              .getMyMentions(userId: mentionedPostSearchQuery!.userId)
              .then((response) async {
            mentionsPostsIsLoading = false;

            mentions.addAll(
                response.success ? response.posts.reversed.toList() : []);

            if (response.posts.length == response.metaData?.perPage) {
              mentionsPostPage += 1;
              canLoadMoreMentionsPosts = true;
            } else {
              canLoadMoreMentionsPosts = false;
            }
            update();
          });
        }
      });
    }
  }
}
