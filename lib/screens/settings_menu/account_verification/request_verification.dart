import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RequestVerification extends StatefulWidget {
  const RequestVerification({Key? key}) : super(key: key);

  @override
  State<RequestVerification> createState() => _RequestVerificationState();
}

class _RequestVerificationState extends State<RequestVerification> {
  final RequestVerificationController _requestVerificationController =
      Get.find();
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            backNavigationBarWithIcon(
                context: context,
                title: LocalizationString.requestVerification,
                icon: ThemeIcon.book,
                iconBtnClicked: () {
                  if (_requestVerificationController
                      .verificationRequests.isNotEmpty) {
                    Get.to(() => RequestVerificationList(
                        requests: _requestVerificationController
                            .verificationRequests));
                  }
                }),
            divider(context: context).tP8,
            const SizedBox(
              height: 20,
            ),
            getIt<UserProfileManager>().user!.isVerified
                ? alreadyVerifiedView()
                : requestVerification(),
          ],
        ),
      ),
    );
  }

  Widget alreadyVerifiedView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocalizationString.verified.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                width: 5,
              ),
              Image.asset(
                'assets/verified.png',
                height: 30,
                width: 30,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            LocalizationString.youAreVerifiedNow,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocalizationString.profileIsVerifiedOn,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                _requestVerificationController.verifiedOn,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: 300,
          ),
        ],
      ),
    );
  }

  Widget requestVerification() {
    return Stack(
      fit: StackFit.loose,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    LocalizationString.applyVerification,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    LocalizationString.verifiedAccountSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationString.messageToReviewer,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(() => InputField(
                                controller: _requestVerificationController
                                    .messageTf.value,
                                backgroundColor: Theme.of(context).cardColor,
                                cornerRadius: 10,
                                maxLines: 5,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        LocalizationString.documentType,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => DropDownField(
                            controller: _requestVerificationController
                                .documentType.value,
                            backgroundColor: Theme.of(context).cardColor,
                            onTap: () {
                              chooseDocumentType();
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: Get.width - 32,
                        height: 40,
                        child: FilledButtonType1(
                            text: LocalizationString.chooseImage,
                            onPress: () {
                              chooseImage();
                            }),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        LocalizationString.uploadFrontAndBack,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ).hP16,
                  SizedBox(
                    height: 80,
                    child: Obx(() => ListView.separated(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: _requestVerificationController
                              .selectedImages.length,
                          itemBuilder: (ctx, index) {
                            return SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  Image.file(
                                    _requestVerificationController
                                        .selectedImages[index],
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ).overlay(Colors.black38),
                                  Positioned(
                                      right: 5,
                                      top: 5,
                                      child: Container(
                                        color: Theme.of(context).primaryColor,
                                        child: const ThemeIconWidget(
                                                ThemeIcon.delete)
                                            .p4,
                                      ).circular.ripple(() {
                                        _requestVerificationController
                                            .deleteDocument(
                                                _requestVerificationController
                                                    .selectedImages[index]);
                                      }))
                                ],
                              ).round(10),
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return const SizedBox(
                              width: 20,
                            );
                          },
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
            left: 16,
            right: 16,
            bottom: 25,
            child: SizedBox(
              width: Get.width - 32,
              height: 40,
              child: FilledButtonType1(
                  text: LocalizationString.submit,
                  onPress: () {
                    submitRequest();
                  }),
            ))
      ],
    );
  }

  submitRequest() {
    _requestVerificationController.submitRequest(context);
  }

  chooseImage() {
    if (_requestVerificationController.selectedImages.length == 2) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.youCanUploadMaximumTwoImages,
          isSuccess: false);
      return;
    }
    picker.pickImage(source: ImageSource.gallery).then((pickedFile) {
      if (pickedFile != null) {
        _requestVerificationController.addDocument(File(pickedFile.path));
      } else {}
    });
  }

  chooseDocumentType() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet1(
              items: [
                GenericItem(
                  id: '1',
                  title: LocalizationString.drivingLicense,
                  subTitle: '',
                  // isSelected: selectedItem?.id == '1',
                ),
                GenericItem(
                  id: '2',
                  title: LocalizationString.passport,
                  subTitle: '',
                  // isSelected: selectedItem?.id == '1',
                ),
                GenericItem(
                  id: '3',
                  title: LocalizationString.panCard,
                  subTitle: '',
                  // isSelected: selectedItem?.id == '1',
                ),
                GenericItem(
                  id: '4',
                  title: LocalizationString.other,
                  subTitle: '',
                  // isSelected: selectedItem?.id == '1',
                ),
              ],
              itemCallBack: (item) {
                if (item.id == '1') {
                  _requestVerificationController.setSelectedDocumentType(
                      LocalizationString.drivingLicense);
                } else if (item.id == '2') {
                  _requestVerificationController
                      .setSelectedDocumentType(LocalizationString.passport);
                } else if (item.id == '3') {
                  _requestVerificationController
                      .setSelectedDocumentType(LocalizationString.panCard);
                } else if (item.id == '4') {
                  _requestVerificationController
                      .setSelectedDocumentType(LocalizationString.other);
                }
              },
            ));
  }
}
