import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectMediaController extends GetxController {
  RxList<Media> mediaList = <Media>[].obs;
  Rx<MediaCount> mediaCount = MediaCount.single.obs;
  final RxList<Media> selectedItems = <Media>[].obs;

  RxInt numberOfItems = 0.obs;
  bool isLoading = false;

  clear(){
    mediaList.clear();
  }

  mediaSelected(List<Media> media){
    mediaList.value = media;
  }

  mediaCountSelected(MediaCount count){
    mediaCount.value = count;
    update();
  }

  // loadGalleryData(BuildContext context) {
  //   getIt<GalleryLoader>().loadGalleryData( mediaType: PostMediaType.all,context: context, completion:(data) {
  //     numberOfItems.value = data.length;
  //     mediaList.value = data;
  //     update();
  //   });
  // }

  // void uploadAllPostImages({required List<GalleryMedia> items}) async {
  //   var responses = await Future.wait(
  //       [for (GalleryMedia media in items) uploadMedia(media)])
  //       .whenComplete(() {});
  //
  //   publishAction(
  //     galleryItems: responses,
  //   );
  // }

  // isSelected(String id) {
  //   return selectedItems.where((item) => item.id == id).isNotEmpty;
  // }
  //
  // selectItem(int index) async {
  //   var galleryImage = mediaList[index];
  //
  //   if (isSelected(galleryImage.id)) {
  //     selectedItems.removeWhere((anItem) => anItem.id == galleryImage.id);
  //     // if (selectedItems.isEmpty) {
  //     //   print('4');
  //     //
  //     //   selectedItems.add(galleryImage);
  //     // }
  //   } else {
  //     if (selectedItems.length < 10) {
  //       selectedItems.add(galleryImage);
  //     }
  //   }
  //
  //   update();
  // }
}
