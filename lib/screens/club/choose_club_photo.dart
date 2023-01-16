import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseClubCoverPhoto extends StatefulWidget {
  final ClubModel club;
  // final Function(ClubModel?) submittedCallback;

  const ChooseClubCoverPhoto(
      {Key? key, required this.club})
      : super(key: key);

  @override
  ChooseClubCoverPhotoState createState() => ChooseClubCoverPhotoState();
}

class ChooseClubCoverPhotoState extends State<ChooseClubCoverPhoto> {
  final CreateClubController _createClubsController = Get.find();
  final ClubDetailController _clubDetailController = Get.find();

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
            context: context,
            title: LocalizationString.addClubCoverPhoto,
          ),
          divider(context: context).tP8,
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationString.addClubPhoto,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                LocalizationString.addClubPhotoSubHeading,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                LocalizationString.coverPhoto,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ).hP16,
          Obx(() => SizedBox(
                height: 250,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _createClubsController.imageFile.value == null
                        ? widget.club.image == null
                            ? Container(
                                child: const ThemeIconWidget(
                                  ThemeIcon.gallery,
                                  size: 100,
                                ).round(5),
                              ).borderWithRadius(
                                context: context, value: 2, radius: 10)
                            : CachedNetworkImage(
                                imageUrl: widget.club.image!,
                                fit: BoxFit.cover,
                              ).round(5)
                        : Image.file(
                            _createClubsController.imageFile.value!,
                            fit: BoxFit.cover,
                          ).round(5),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          color: Theme.of(context).cardColor,
                          child: Row(
                            children: [
                              ThemeIconWidget(
                                ThemeIcon.edit,
                                size: 20,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Text(
                                LocalizationString.edit,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          )
                              .setPadding(left: 8, right: 8, top: 4, bottom: 4)
                              .borderWithRadius(
                                  context: context, value: 2, radius: 5),
                        ).ripple(() {
                          picker
                              .pickImage(source: ImageSource.gallery)
                              .then((pickedFile) {
                            if (pickedFile != null) {
                              _createClubsController.editClubImageAction(
                                  pickedFile, context);
                            } else {}
                          });
                        }))
                  ],
                ),
              )).p16,
          const Spacer(),
          FilledButtonType1(
              text: widget.club.id == null
                  ? LocalizationString.createClub
                  : LocalizationString.update,
              onPress: () {
                if (widget.club.id == null) {
                  createBtnClicked();
                } else {
                  updateBtnClicked();
                }
              }).hP16,
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  createBtnClicked() {
    if (_createClubsController.imageFile.value == null) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterSelectCubImage,
          isSuccess: false);
      return;
    }
    _createClubsController.createClub(widget.club, context, () {
      // widget.submittedCallback(null);
    });
  }

  updateBtnClicked() {
    _createClubsController.updateClubImage(widget.club, context, (club) {
      // widget.submittedCallback(widget.club);
      _clubDetailController.setEvent(widget.club);

    });
  }
}
