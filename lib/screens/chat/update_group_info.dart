import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class UpdateGroupInfo extends StatefulWidget {
  final ChatRoomModel group;

  const UpdateGroupInfo({Key? key, required this.group}) : super(key: key);

  @override
  State<UpdateGroupInfo> createState() => _UpdateGroupInfoState();
}

class _UpdateGroupInfoState extends State<UpdateGroupInfo> {
  final EnterGroupInfoController enterGroupInfoController = Get.find();

  final TextEditingController groupName = TextEditingController();
  final TextEditingController groupDescription = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    groupName.text = widget.group.name!;
    groupDescription.text = widget.group.description ?? '';

    super.initState();
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
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ThemeIconWidget(
                      ThemeIcon.close,
                      size: 20,
                    ).ripple(() {
                      Navigator.of(context).pop();
                    }),
                    Text(
                      LocalizationString.update,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).ripple(() {
                      updateGroup();
                    }),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      LocalizationString.createGroup,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              ],
            ),
          ).hP16,
          divider(context: context).tP8,
          SizedBox(
            height: 250,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Obx(() => Container(
                          height: 50,
                          width: 50,
                          color: Theme.of(context).cardColor.darken(),
                          child:
                              enterGroupInfoController.groupImagePath.isNotEmpty
                                  ? Image.file(
                                      File(enterGroupInfoController
                                          .groupImagePath.value),
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    )
                                  : widget.group.image != null &&
                                          widget.group.image?.isNotEmpty == true
                                      ? CachedNetworkImage(
                                          imageUrl: widget.group.image!,
                                          fit: BoxFit.cover,
                                          height: 50,
                                          width: 50,
                                        )
                                      : const ThemeIconWidget(
                                          ThemeIcon.camera,
                                          size: 15,
                                        ),
                        ).circular.ripple(() {
                          openImagePickingPopup();
                        })),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InputField(
                        controller: groupName,
                        showDivider: true,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        hintText: LocalizationString.groupName,
                        cornerRadius: 5,
                      ),
                    )
                  ],
                ),
                InputField(
                  maxLines: 5,
                  controller: groupDescription,
                  showDivider: true,
                  textStyle: Theme.of(context).textTheme.titleSmall,
                  hintText: LocalizationString.describeAboutGroup,
                  cornerRadius: 5,
                )
              ],
            ),
          ).hP16,
        ],
      ),
    );
  }

  updateGroup() {
    if (groupName.text.isEmpty) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterGroupName,
          isSuccess: false);
      return;
    }

    enterGroupInfoController.updateGroup(
        group: widget.group,
        name: groupName.text,
        description: groupDescription.text,
        image: enterGroupInfoController.groupImagePath.value,
        context: context);
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
                          enterGroupInfoController
                              .groupImageSelected(pickedFile.path);
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
                          enterGroupInfoController
                              .groupImageSelected(pickedFile.path);
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
