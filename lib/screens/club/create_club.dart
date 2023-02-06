import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CreateClub extends StatefulWidget {
  final ClubModel club;

  const CreateClub({Key? key, required this.club}) : super(key: key);

  @override
  CreateClubState createState() => CreateClubState();
}

class CreateClubState extends State<CreateClub> {
  final CreateClubController _createClubController = Get.find();
  final ClubDetailController _clubDetailController = Get.find();

  final TextEditingController nameText = TextEditingController();
  final TextEditingController descText = TextEditingController();

  GenericItem? selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.club.id != null) {
      nameText.text = widget.club.name!;
      descText.text = widget.club.desc!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  backNavigationBar(
                    context: context,
                    title: widget.club.id == null
                        ? LocalizationString.createClub
                        : LocalizationString.editClubInfo,
                  ),
                  divider(context: context).tP8,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        LocalizationString.basicInfo,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputField(
                        controller: nameText,
                        showBorder: true,
                        cornerRadius: 5,
                        hintText: LocalizationString.clubName,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputField(
                        controller: descText,
                        showBorder: true,
                        cornerRadius: 5,
                        maxLines: 5,
                        hintText: LocalizationString.clubDescription,
                      ),

                      if (widget.club.id == null) selectGroupPrivacyWidget(),

                      if (widget.club.id == null) chatGroupWidget(),

                      // const Spacer(),
                    ],
                  ).hP16,
                ],
              ),
            ),
          ),
          Positioned(
              left: 16,
              right: 16,
              bottom: 25,
              child: FilledButtonType1(
                  text: widget.club.id == null
                      ? LocalizationString.next
                      : LocalizationString.update,
                  onPress: () {
                    nextBtnClicked();
                  }))
        ],
      ),
    );
  }

  Widget chatGroupWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50,
        ),
        Text(
          LocalizationString.communication,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(() => privacyTypeWidget(
            id: 4,
            title: LocalizationString.chatGroup,
            subTitle: LocalizationString.createChatGroupForDiscussion,
            isSelected: _createClubController.enableChat.value,
            icon: ThemeIcon.chat,
            callback: () {
              _createClubController.toggleChatGroup();
            })),
      ],
    );
  }

  Widget selectGroupPrivacyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Text(
          LocalizationString.privacy,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(() => privacyTypeWidget(
            id: 2,
            title: LocalizationString.public,
            subTitle: LocalizationString.anyoneCanSeeClub,
            isSelected: _createClubController.privacyType.value == 1,
            icon: ThemeIcon.public,
            callback: () {
              _createClubController.privacyTypeChange(1);
            })),
        const SizedBox(
          height: 20,
        ),
        Obx(() => privacyTypeWidget(
            id: 1,
            title: LocalizationString.private,
            subTitle: LocalizationString.onlyMembersCanSeeClub,
            isSelected: _createClubController.privacyType.value == 2,
            icon: ThemeIcon.lock,
            callback: () {
              _createClubController.privacyTypeChange(2);
            })),
        const SizedBox(
          height: 20,
        ),
        Obx(() => privacyTypeWidget(
            id: 3,
            title: LocalizationString.onRequest,
            subTitle: LocalizationString.onClubRequestJoin,
            isSelected: _createClubController.privacyType.value == 3,
            icon: ThemeIcon.request,
            callback: () {
              _createClubController.privacyTypeChange(3);
            })),
      ],
    );
  }

  Widget privacyTypeWidget(
      {required int id,
      required ThemeIcon icon,
      required String title,
      required String subTitle,
      required bool isSelected,
      required VoidCallback callback}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
                color: Theme.of(context).primaryColor.lighten(0.1),
                child: ThemeIconWidget(
                  icon,
                  color: Theme.of(context).iconTheme.color,
                ).p4)
            .circular,
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        // Spacer(),
        ThemeIconWidget(
          isSelected ? ThemeIcon.selectedCheckbox : ThemeIcon.emptyCheckbox,
          size: 25,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).iconTheme.color,
        )
      ],
    ).ripple(() {
      callback();
    });
  }

  // showActionSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (context) => ActionSheet(
  //             items: [
  //               GenericItem(
  //                   id: '1',
  //                   title: LocalizationString.public,
  //                   subTitle: LocalizationString.anyoneCanSeeClub,
  //                   isSelected: selectedItem?.id == '1',
  //                   icon: ThemeIcon.public),
  //               GenericItem(
  //                   id: '2',
  //                   title: LocalizationString.private,
  //                   subTitle: LocalizationString.onlyMembersCanSeeClub,
  //                   isSelected: selectedItem?.id == '2',
  //                   icon: ThemeIcon.lock),
  //             ],
  //             itemCallBack: (item) {
  //               setState(() {
  //                 selectedItem = item;
  //               });
  //             },
  //           ));
  // }

  nextBtnClicked() {
    if (nameText.text.isEmpty) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterClubName,
          isSuccess: false);
      return;
    }
    if (descText.text.isEmpty) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterClubDesc,
          isSuccess: false);
      return;
    }

    widget.club.name = nameText.text;
    widget.club.desc = descText.text;

    if (widget.club.id == null) {
      widget.club.enableChat = _createClubController.enableChat.value ? 1 : 0;
      Get.to(() => ChooseClubCoverPhoto(
            club: widget.club,
          ));
    } else {
      _createClubController.updateClubInfo(
          club: widget.club,
          callback: () {
            _clubDetailController.setEvent(widget.club);
          });
    }
  }
}
