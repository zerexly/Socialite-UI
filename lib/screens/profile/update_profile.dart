import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/profile/pref/add_interests.dart';
import 'package:foap/screens/profile/pref/add_personal_info.dart';
import 'package:foap/screens/profile/pref/add_profesional_details.dart';
import 'package:get/get.dart';

import '../login_sign_up/set_profile_category_type.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends State<UpdateProfile> {
  bool isLoading = true;
  final picker = ImagePicker();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
    reloadData();
  }

  reloadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.setUser(getIt<UserProfileManager>().user!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
              context: context, title: LocalizationString.editProfile),
          divider(context: context).vP8,
          addProfileView(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        LocalizationString.userName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Obx(() => profileController.user.value != null
                          ? Text(
                              profileController.user.value!.userName,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Container()),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const ChangeUserName())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.category,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Obx(() => profileController.user.value != null
                          ? Text(
                              profileController.user.value!.category,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Container()),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const SetProfileCategoryType(
                                  isFromSignup: false,
                                ))!
                            .then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.password,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '********',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const ChangePassword());
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.phoneNumber,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Obx(() => profileController.user.value != null
                          ? Text(
                              profileController.user.value!.phone ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Container()),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const ChangePhoneNumber())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.paymentDetail,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Obx(() => profileController.user.value != null
                          ? Text(
                              profileController.user.value!.paypalId ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          : Container()),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const ChangePaypalId())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.location,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Obx(() => Text(
                            '${profileController.user.value?.country ?? ''} ${profileController.user.value?.city ?? ''}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const ChangeLocation())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.currentLocation,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const SetLocation())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const AddName())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.dob,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const SetDateOfBirth())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.gender,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const SetYourGender())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.personalDetails,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const AddPersonalInfo())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.interests,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const AddInterests())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                  Row(
                    children: [
                      Text(
                        LocalizationString.professional,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 15,
                      ).ripple(() {
                        Get.to(() => const AddProfessionalDetails())!.then((value) {
                          reloadData();
                        });
                      })
                    ],
                  ),
                  divider(context: context).vP16,
                ],
              ).hP16,
            ),
          ),
          // Row(
          //   children: [
          //     Container(
          //       color: AppTheme.themeColor.withOpacity(0.1),
          //       height: 43,
          //       width: 43,
          //       child:
          //           ThemeIconWidget(ThemeIcon.lock, color: AppTheme.themeColor),
          //     ).circular,
          //     const SizedBox(
          //       width: 15,
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(LocalizationString.faceIdTouchId,
          //                 style: Theme.of(context).textTheme.titleMedium.primaryColor.bold)
          //             .bP4,
          //         Text(LocalizationString.manageDeviceSecurity,
          //             style: Theme.of(context).textTheme.bodyLarge),
          //       ],
          //     ),
          //     const Spacer(),
          //     Obx(() => Switch(
          //         value:
          //             profileController.user.value.isBioMetricLoginEnabled == 1,
          //         onChanged: (value) {
          //           profileController.updateBioMetricSetting(value);
          //         }))
          //   ],
          // ).hP16
        ],
      ),
    );
  }

  addProfileView() {
    return GetBuilder<ProfileController>(
        init: profileController,
        builder: (ctx) {
          return SizedBox(
            height: 210,
            child: profileController.user.value != null
                ? Column(children: [
                    const SizedBox(
                      height: 20,
                    ),
                    UserAvatarView(
                            user: profileController.user.value!,
                            size: 65,
                            onTapHandler: () {})
                        .ripple(() {
                      openImagePickingPopup();
                    }),
                    Text(
                      LocalizationString.editProfilePicture,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ).vP4.ripple(() {
                      openImagePickingPopup();
                    }),
                    Text(
                      profileController.user.value!.userName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).setPadding(bottom: 4),
                    profileController.user.value?.email != null
                        ? Text(
                            '${profileController.user.value!.email}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor),
                          )
                        : Container(),
                    profileController.user.value?.country != null
                        ? Text(
                            '${profileController.user.value?.country ?? ''},${profileController.user.value?.city ?? ''}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context).backgroundColor),
                          ).vP4
                        : Container(),
                  ]).p8
                : Container(),
          );
        });
  }

  void openImagePickingPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 25),
                    child: Text(LocalizationString.addPhoto,
                        style: Theme.of(context).textTheme.bodyLarge)),
                ListTile(
                    leading: Icon(Icons.camera_alt_outlined,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(LocalizationString.takePhoto),
                    onTap: () {
                      Get.back();
                      picker
                          .pickImage(source: ImageSource.camera)
                          .then((pickedFile) {
                        if (pickedFile != null) {
                          profileController.editProfileImageAction(
                              pickedFile, context);
                        } else {}
                      });
                    }),
                divider(context: context),
                ListTile(
                    leading: Icon(Icons.wallpaper_outlined,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(LocalizationString.chooseFromGallery),
                    onTap: () async {
                      Get.back();
                      picker
                          .pickImage(source: ImageSource.gallery)
                          .then((pickedFile) {
                        if (pickedFile != null) {
                          profileController.editProfileImageAction(
                              pickedFile, context);
                        } else {}
                      });
                    }),
                divider(context: context),
                ListTile(
                    leading: Icon(Icons.close,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(LocalizationString.cancel),
                    onTap: () => Get.back()),
              ],
            ));
  }
}
