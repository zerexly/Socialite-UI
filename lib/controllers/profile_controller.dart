import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../screens/login_sign_up/set_profile_category_type.dart';

class ProfileController extends GetxController {
  final PostController postController = Get.find<PostController>();

  Rx<UserModel?> user = Rx<UserModel?>(null);

  int totalPages = 100;

  RxInt userNameCheckStatus = (-1).obs;
  RxBool isLoading = true.obs;

  RxList<PaymentModel> payments = <PaymentModel>[].obs;
  RxInt selectedSegment = 0.obs;

  RxBool noDataFound = false.obs;

  bool isLoadingPosts = false;
  int postsCurrentPage = 1;
  bool canLoadMorePosts = true;

  bool isLoadingReels = false;
  int reelsCurrentPage = 1;
  bool canLoadMoreMoments = true;

  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<PostModel> mentions = <PostModel>[].obs;
  RxList<PostModel> reels = <PostModel>[].obs;

  int mentionsPostPage = 1;
  bool canLoadMoreMentionsPosts = true;
  bool mentionsPostsIsLoading = false;

  Rx<GiftModel?> sendingGift = Rx<GiftModel?>(null);

  clear() {
    selectedSegment.value = 0;

    isLoadingPosts = false;
    postsCurrentPage = 1;
    canLoadMorePosts = true;

    isLoadingReels = false;
    reelsCurrentPage = 1;
    canLoadMoreMoments = true;

    mentionsPostPage = 1;
    canLoadMoreMentionsPosts = true;
    mentionsPostsIsLoading = false;

    totalPages = 100;

    posts.clear();
    mentions.clear();
    reels.clear();
  }

  getMyProfile() async {
    // user.value = getIt<UserProfileManager>().user!;
    // update();
    await getIt<UserProfileManager>().refreshProfile();
    user.value = getIt<UserProfileManager>().user!;
    update();
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

              user.value!.country = country;
              user.value!.city = city;
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

  updateUserName(
      {required String userName,
      required isSigningUp,
      required BuildContext context}) {
    if (FormValidator().isTextEmpty(userName)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterUserName,
          isSuccess: false);
    } else if (userNameCheckStatus.value != 1) {
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
              getMyProfile();
              if (isSigningUp == true) {
                Get.to(() => const SetProfileCategoryType(
                      isFromSignup: false,
                    ));
              } else {
                Future.delayed(const Duration(milliseconds: 1200), () {
                  Get.back();
                });
              }
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

  updateProfileCategoryType(
      {required int profileCategoryType,
      required isSigningUp,
      required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController()
            .updateUserName(profileCategoryType.toString())
            .then((response) {
          if (response.success == true) {
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context,
                message: LocalizationString.userNameIsUpdated,
                isSuccess: true);
            getMyProfile();
            if (isSigningUp == true) {
              if (isLoginFirstTime) {
                Get.to(() => const SetLocation())!.then((value) {});
              } else {
                isLoginFirstTime = false;
                getIt<LocationManager>().postLocation();
                Get.offAll(() => const DashboardScreen());
              }
            } else {
              Future.delayed(const Duration(milliseconds: 1200), () {
                Get.back();
              });
            }
          } else {
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: false);
          }
        });
      }
    });
  }

  void verifyUsername({required String userName}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        ApiController().checkUsername(userName).then((response) async {
          if (response.success) {
            userNameCheckStatus.value = 1;
          } else {
            userNameCheckStatus.value = 0;
          }
          update();
        });
      } else {
        userNameCheckStatus.value = 0;
      }
    });
  }

  void editProfileImageAction(XFile pickedFile, BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);

        Uint8List compressedData = await File(pickedFile.path)
            .compress(minHeight: 200, minWidth: 200, byQuality: 50);
        ApiController()
            .updateProfileImage(compressedData)
            .then((response) async {
          EasyLoading.dismiss();

          getIt<UserProfileManager>().refreshProfile().then((value) {
            user.value = getIt<UserProfileManager>().user;
            update();
          });
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
    user.value!.isBioMetricLoginEnabled = value == true ? 1 : 0;
    SharedPrefs().setBioMetricAuthStatus(value);

    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController()
            .updateBiometricSetting(user.value!.isBioMetricLoginEnabled ?? 0)
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
      {required bool isFollowing, required BuildContext context}) {
    user.value!.isFollowing = isFollowing;
    update();
    AppUtil.checkInternet().then((value) {
      if (value) {
        ApiController()
            .followUnFollowUser(isFollowing, user.value!.id)
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
    user.value!.isReported = true;
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().reportUser(user.value!.id).then((response) async {
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
    user.value!.isReported = true;
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().blockUser(user.value!.id).then((response) async {
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

  void withdrawalRequest(BuildContext context) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().performWithdrawalRequest().then((response) async {
          getMyProfile();
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

  void redeemRequest(int coins, BuildContext context, VoidCallback callback) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().redeemCoinsRequest(coins).then((response) async {
          EasyLoading.dismiss();
          await getMyProfile();
          callback();
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
    user.isFollowing = true;
    update();
    ApiController().followUnFollowUser(true, user.id).then((value) {});
  }

  unFollowUser(UserModel user) {
    user.isFollowing = false;

    update();
    ApiController().followUnFollowUser(false, user.id).then((value) {});
  }

  //******************** Posts ****************//

  void getPosts(int userId) async {
    if (canLoadMorePosts == true && totalPages > postsCurrentPage) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingPosts = true;
          ApiController()
              .getPosts(userId: userId, page: postsCurrentPage)
              .then((response) async {
            // posts.value = [];
            posts.addAll(response.success
                ? response.posts
                    .where((element) => element.gallery.isNotEmpty)
                    .toList()
                : []);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingPosts = false;

            postsCurrentPage += 1;

            if (response.posts.length == response.metaData?.perPage) {
              canLoadMorePosts = true;
            } else {
              canLoadMorePosts = false;
            }
            totalPages = response.metaData!.pageCount;
            update();
          });
        }
      });
    }
  }

  void getReels(int userId) async {
    if (canLoadMoreMoments == true) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingReels = true;
          ApiController()
              .getPosts(userId: userId, isReel: 1, page: reelsCurrentPage)
              .then((response) async {
            reels.addAll(response.success
                ? response.posts
                    .where((element) => element.gallery.isNotEmpty)
                    .toList()
                : []);
            reels.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingReels = false;

            reelsCurrentPage += 1;

            if (response.posts.length == response.metaData?.perPage) {
              canLoadMoreMoments = true;
            } else {
              canLoadMoreMoments = false;
            }
            // totalPages = response.metaData!.pageCount;
            update();
          });
        }
      });
    }
  }

  void getMyMentions(int userId) {
    if (canLoadMoreMentionsPosts && totalPages > mentionsPostPage) {
      AppUtil.checkInternet().then((value) {
        if (value) {
          mentionsPostsIsLoading = true;
          ApiController().getMyMentions(userId: userId).then((response) async {
            mentionsPostsIsLoading = false;

            mentions.addAll(
                response.success ? response.posts.reversed.toList() : []);

            mentionsPostPage += 1;
            if (response.posts.length == response.metaData?.perPage) {
              canLoadMoreMentionsPosts = true;
              totalPages = response.metaData!.pageCount;
            } else {
              canLoadMoreMentionsPosts = false;
            }
            update();
          });
        }
      });
    }
  }

  sendGift(GiftModel gift) {
    if (getIt<UserProfileManager>().user!.coins > gift.coins) {
      sendingGift.value = gift;
      ApiController()
          .sendGift(
              gift: gift, liveId: null, userId: user.value!.id, postId: null)
          .then((value) {
        Timer(const Duration(seconds: 1), () {
          sendingGift.value = null;
        });

        // refresh profile to get updated wallet info
        getIt<UserProfileManager>().refreshProfile();
      });
    } else {}
  }
}
