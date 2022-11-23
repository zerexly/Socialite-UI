import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CreateHighlight extends StatefulWidget {
  const CreateHighlight({Key? key}) : super(key: key);

  @override
  State<CreateHighlight> createState() => _CreateHighlightState();
}

class _CreateHighlightState extends State<CreateHighlight> {
  final HighlightsController highlightsController = Get.find();
  TextEditingController nameText = TextEditingController();
  final picker = ImagePicker();

  @override
  void initState() {
    highlightsController.updateCoverImagePath();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 55,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).primaryColor,
                size: 20,
              ).ripple(() {
                Get.back();
              }),
              const Spacer(),
              Text(
                LocalizationString.create,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).primaryColor)
                    .copyWith(fontWeight: FontWeight.w600),
              ).ripple(() {
                // create highlights
                if (nameText.text.isNotEmpty) {
                  highlightsController.createHighlights(name: nameText.text);
                }
                else{
                  AppUtil.showToast(context: context, message: LocalizationString.pleaseEnterTitle, isSuccess: false);
                }
              }),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          addProfileView(),
          Text(
            LocalizationString.chooseCoverImage,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).primaryColor)
                .copyWith(fontWeight: FontWeight.w900),
          ).ripple(() {
            openImagePickingPopup();
          }),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: TextField(
              controller: nameText,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall,
              maxLines: 5,
              onChanged: (text) {},
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(left: 10, right: 10),
                  counterText: "",
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).primaryColor),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                  hintText: LocalizationString.enterHighlightName),
            ),
          )
        ],
      ).hP16,
    );
  }

  addProfileView() {
    return SizedBox(
      height: 100,
      child: Column(children: [
        GetBuilder<HighlightsController>(
                init: highlightsController,
                builder: (ctx) {
                  return Container(
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: highlightsController.pickedImage != null
                          ? Image.file(
                              highlightsController.pickedImage!,
                              fit: BoxFit.cover,
                              height: 64,
                              width: 64,
                            ).circular
                          : highlightsController.model == null ||
                                  highlightsController.model?.picture == null
                              ? CachedNetworkImage(
  imageUrl:
                                  highlightsController
                                      .selectedStoriesMedia.first.image!,
                                  fit: BoxFit.cover,
                                  height: 64,
                                  width: 64,
                                ).circular
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(32.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        highlightsController.model!.picture!,
                                    fit: BoxFit.cover,
                                    height: 64.0,
                                    width: 64.0,
                                    placeholder: (context, url) =>
                                        AppUtil.addProgressIndicator(context,100),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  )),
                    ).p4,
                  );
                })
            .borderWithRadius(
                context: context,
                value: 2,
                radius: 40,
                color: Theme.of(context).primaryColor)
            .ripple(() {
          openImagePickingPopup();
        })
      ]).p8,
    );
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
                    leading: const Icon(Icons.camera_alt_outlined,
                        color: Colors.black87),
                    title: Text(LocalizationString.takePhoto,
                        style: Theme.of(context).textTheme.bodyLarge),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.camera);
                      if (pickedFile != null) {
                        highlightsController
                            .updateCoverImage(File(pickedFile.path));
                      } else {}
                    }),
                divider(context: context),
                ListTile(
                    leading: const Icon(Icons.wallpaper_outlined,
                        color: Colors.black87),
                    title: Text(
                      LocalizationString.chooseFromGallery,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        highlightsController
                            .updateCoverImage(File(pickedFile.path));
                      } else {}
                    }),
                divider(context: context),
                ListTile(
                    leading: const Icon(Icons.close, color: Colors.black87),
                    title: Text(LocalizationString.cancel),
                    onTap: () => Get.back()),
              ],
            ));
  }
}
