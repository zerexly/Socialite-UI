import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import '../../../model/preference_model.dart';

class AddPhotos extends StatefulWidget {
  const AddPhotos({Key? key}) : super(key: key);

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  final picker = ImagePicker();
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationString.addPhotoHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            Text(
              LocalizationString.addPhotoSubHeader,
              style: Theme.of(context).textTheme.titleSmall,
            ).paddingOnly(top: 20),
            GridView.builder(
                itemCount: 6,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // You won't see infinite size error
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 20.0,
                    mainAxisExtent: 100),
                itemBuilder: (ctx, index) {
                  return addImagePickingView(index);
                }).paddingOnly(top: 50),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        getIt<AddPreferenceManager>().preferenceModel?.images =
                            images;
                        Get.to(() => const SetDateOfBirth());
                      })),
            ).paddingOnly(top: 110),
          ],
        ).hP25,
      ),
    );
  }

  addImagePickingView(int index) {
    return Container(
      height: 100,
      width: 100,
      color: Colors.white,
      child: images.asMap().containsKey(index)
          ? Image.file(File(images[index].path), fit: BoxFit.cover)
          : const Icon(
              Icons.add,
              size: 25,
            ),
    ).round(10).ripple(() {
      images.asMap().containsKey(index)
          ? openImageRemovePopup(index)
          : openImagePickingPopup();
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
                          setState(() {
                            images.add(pickedFile);
                          });
                        }
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
                          setState(() {
                            images.add(pickedFile);
                          });
                        }
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

  void openImageRemovePopup(int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 25),
                    child: Text(LocalizationString.removePhoto,
                        style: Theme.of(context).textTheme.bodyLarge)),
                ListTile(
                    leading: Icon(Icons.delete,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(LocalizationString.remove),
                    onTap: () {
                      Get.back();
                      setState(() {
                        images.removeAt(index);
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
