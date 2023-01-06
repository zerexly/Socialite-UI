import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class AddPostController extends GetxController {
  final HomeController _homeController = Get.find();

  RxInt isEditing = 0.obs;
  RxString currentHashtag = ''.obs;
  RxString currentUserTag = ''.obs;
  RxInt currentIndex = 0.obs;

  RxBool isPosting = false.obs;
  RxBool isErrorInPosting = false.obs;

  List<Media> postingMedia = [];
  late String postingTitle;

  RxList<Hashtag> hashTags = <Hashtag>[].obs;
  RxList<UserModel> searchedUsers = <UserModel>[].obs;

  int currentUpdateAbleStartOffset = 0;
  int currentUpdateAbleEndOffset = 0;
  RxBool allowComments = true.obs;

  RxString searchText = ''.obs;
  RxInt position = 0.obs;

  RxBool isPreviewMode = false.obs;

  int hashtagsPage = 1;
  bool canLoadMoreHashtags = true;
  bool hashtagsIsLoading = false;

  int accountsPage = 1;
  bool canLoadMoreAccounts = true;
  bool accountsIsLoading = false;

  clear() {
    hashtagsPage = 1;
    canLoadMoreHashtags = true;
    hashtagsIsLoading = false;

    accountsPage = 1;
    canLoadMoreAccounts = true;
    accountsIsLoading = false;
    update();
  }

  updateGallerySlider(int index) {
    currentIndex.value = index;
    update();
  }

  togglePreviewMode() {
    isPreviewMode.value = !isPreviewMode.value;
    update();
  }

  startedEditing() {
    isEditing.value = 1;
    update();
  }

  stoppedEditing() {
    isEditing.value = 0;
    update();
  }

  searchHashTags({required String text}) {
    if (canLoadMoreHashtags) {
      hashtagsIsLoading = true;

      ApiController()
          .searchHashtag(hashtag: text.replaceAll('#', ''))
          .then((response) {
        hashTags.value = response.hashtags;

        hashtagsIsLoading = false;
        hashtagsPage += 1;
        if (response.hashtags.length == response.metaData?.perPage) {
          canLoadMoreHashtags = true;
        } else {
          canLoadMoreHashtags = false;
        }

        update();
      });
    }
  }

  addUserTag(String user) {
    String updatedText = searchText.value.replaceRange(
        currentUpdateAbleStartOffset, currentUpdateAbleEndOffset, '$user ');
    searchText.value = updatedText;
    position.value = updatedText.indexOf(user, currentUpdateAbleStartOffset) +
        user.length +
        1;

    currentUserTag.value = '';

    update();
  }

  addHashTag(String hashtag) {
    String updatedText = searchText.value.replaceRange(
        currentUpdateAbleStartOffset, currentUpdateAbleEndOffset, '$hashtag ');
    position.value =
        updatedText.indexOf(hashtag, currentUpdateAbleStartOffset) +
            hashtag.length +
            1;

    searchText.value = updatedText;
    currentHashtag.value = '';

    update();
  }

  searchUsers(String text) {
    if (canLoadMoreAccounts) {
      accountsIsLoading = true;
      ApiController()
          .findFriends(isExactMatch: 0, searchText: text.replaceAll('@', ''))
          .then((response) {
        searchedUsers.value = response.users;
        accountsIsLoading = false;

        accountsPage += 1;
        if (response.topUsers.length == response.metaData?.perPage) {
          canLoadMoreAccounts = true;
        } else {
          canLoadMoreAccounts = false;
        }
        update();
      });
    }
  }

  textChanged(String text, int position) {
    clear();
    isEditing.value = 1;
    searchText.value = text;
    String substring = text.substring(0, position).replaceAll("\n", " ");
    List<String> parts = substring.split(' ');
    String lastPart = parts.last;

    if (lastPart.startsWith('#') == true && lastPart.contains('@') == false) {
      if (currentHashtag.value.startsWith('#') == false) {
        currentHashtag.value = lastPart;
        currentUpdateAbleStartOffset = position;
      }

      if (lastPart.length > 1) {
        searchHashTags(text: lastPart);
        currentUpdateAbleEndOffset = position;
      }
    } else if (lastPart.startsWith('@') == true &&
        lastPart.contains('#') == false) {
      if (currentUserTag.value.startsWith('@') == false) {
        currentUserTag.value = lastPart;
        currentUpdateAbleStartOffset = position;
      }
      if (lastPart.length > 1) {
        searchUsers(lastPart);
        currentUpdateAbleEndOffset = position;
      }
    } else {
      if (currentHashtag.value.startsWith('#') == true) {
        currentHashtag.value = lastPart;
      }
      currentHashtag.value = '';
      hashTags.value = [];

      if (currentUserTag.value.startsWith('!') == true) {
        currentUserTag.value = lastPart;
      }
      currentUserTag.value = '';
      searchedUsers.value = [];
    }

    this.position.value = position;
  }

  toggleAllowCommentsSetting() {
    allowComments.value = !allowComments.value;
  }

  discardFailedPost() {
    postingMedia = [];
    postingTitle = '';
    isPosting.value = false;
    isErrorInPosting.value = false;
    clear();
  }

  retryPublish(BuildContext context) {
    uploadAllPostFiles(
        items: postingMedia, title: postingTitle, context: context);
  }

  void uploadAllPostFiles(
      {required List<Media> items,
      required String title,
      required BuildContext context,
      int? competitionId,
      int? clubId,
      bool isReel = false,
      int? audioId,
      double? audioStartTime,
      double? audioEndTime}) async {
    postingMedia = items;
    postingTitle = title;
    isPosting.value = true;

    if (competitionId == null && clubId == null) {
      Get.offAll(() => const DashboardScreen());
    } else {
      EasyLoading.show(status: LocalizationString.loading);
    }

    var responses = await Future.wait([
      for (Media media in items) uploadMedia(media, competitionId, context)
    ]).whenComplete(() {});

    publishAction(
        galleryItems: responses,
        title: title,
        tags: title.getHashtags(),
        mentions: title.getMentions(),
        competitionId: competitionId,
        clubId: clubId,
        isReel: isReel,
        audioId: audioId,
        audioStartTime: audioStartTime,
        audioEndTime: audioEndTime,
        context: context);
  }

  Future<Map<String, String>> uploadMedia(
      Media media, int? competitionId, BuildContext context) async {
    Map<String, String> gallery = {};

    await AppUtil.checkInternet().then((value) async {
      if (value) {
        final tempDir = await getTemporaryDirectory();
        File file;
        String? videoThumbnailPath;

        if (media.mediaType == GalleryMediaType.photo) {
          Uint8List mainFileData = await media.file!.compress();

          //image media
          file =
              await File('${tempDir.path}/${media.id!.replaceAll('/', '')}.png')
                  .create();
          file.writeAsBytesSync(mainFileData);
        } else {
          Uint8List mainFileData = media.file!.readAsBytesSync();

          // video
          file =
              await File('${tempDir.path}/${media.id!.replaceAll('/', '')}.mp4')
                  .create();
          file.writeAsBytesSync(mainFileData);

          File videoThumbnail = await File(
                  '${tempDir.path}/${media.id!.replaceAll('/', '')}_thumbnail.png')
              .create();

          videoThumbnail.writeAsBytesSync(media.thumbnail!);

          await ApiController()
              .uploadPostMedia(videoThumbnail.path)
              .then((response) async {
            videoThumbnailPath = response.postedMediaFileName!;
            await videoThumbnail.delete();
          });
        }

        // EasyLoading.show(status: LocalizationString.loading);
        await ApiController().uploadPostMedia(file.path).then((response) async {
          String imagePath = response.postedMediaFileName!;

          await file.delete();

          gallery = {
            'filename': imagePath,
            'video_thumb': videoThumbnailPath ?? '',
            'type': competitionId == null ? '1' : '2',
            'media_type': media.mediaType == GalleryMediaType.photo ? '1' : '2',
            'is_default': '1',
          };
        });
      } else {
        isErrorInPosting.value = true;
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
    return gallery;
  }

  void publishAction({
    required List<Map<String, String>> galleryItems,
    required String title,
    required List<String> tags,
    required List<String> mentions,
    required BuildContext context,
    int? competitionId,
    int? clubId,
    bool isReel = false,
    int? audioId,
    double? audioStartTime,
    double? audioEndTime,
  }) {
    AppUtil.checkInternet().then((value) async {
      // EasyLoading.dismiss();
      if (value) {
        ApiController()
            .addPost(
                postType: isReel == true
                    ? 4
                    : competitionId != null
                        ? 2
                        : clubId != null
                            ? 3
                            : 1,
                title: title,
                gallery: galleryItems,
                hashTag: tags.join(','),
                mentions: mentions.join(','),
                competitionId: competitionId,
                clubId: clubId,
                audioId: audioId,
                audioStartTime: audioStartTime,
                audioEndTime: audioEndTime)
            .then((response) async {
          // Get.offAll(() => const DashboardScreen());

          if (competitionId != null || clubId != null) {
            EasyLoading.dismiss();
            Get.offAll(() => const DashboardScreen());
          }

          postingMedia = [];
          postingTitle = '';

          ApiController()
              .getPostDetail(response.createdPostId)
              .then((response) {
            if (response.post != null) {
              _homeController.addNewPost(response.post!);
            }
            isPosting.value = false;
          });
          clear();
        });
      } else {
        isErrorInPosting.value = true;

        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

// loadMedia(
//     {required BuildContext context,
//     required PostMediaType mediaType,
//     required bool canSelectMultiple}) async {
//   mediaList.clear();
//   numberOfItems.value = 0;
//   // _channel
//   //     .invokeMethod<int>(
//   //         "getItemCount",
//   //         mediaType == PostMediaType.photo
//   //             ? 1
//   //             : mediaType == PostMediaType.video
//   //                 ? 2
//   //                 : 3)
//   //     .then((count) {
//   //   numberOfItems.value = count ?? 0;
//   // });
//
//   getIt<GalleryLoader>().loadGalleryData(
//       mediaType: mediaType,
//       context: context,
//       completion: (data) {
//         mediaList.value = data;
//         numberOfItems.value = mediaList.length;
//         if (mediaList.isNotEmpty) {
//           selectItem(index: 0, canSelectMultiple: canSelectMultiple);
//         }
//       });
// }

// Future<GalleryMedia> getItem(
//     {required int index, required PostMediaType mediaType}) async {
//   if (itemCache[index] != null) {
//     return await getCachedItem(index);
//   } else {
//     var channelResponse = await _channel.invokeMethod("getItem", {
//       'index': index,
//       'mediaType': mediaType == PostMediaType.photo
//           ? 1
//           : mediaType == PostMediaType.video
//               ? 2
//               : 3
//     });
//     var item = Map<String, dynamic>.from(channelResponse);
//     var galleryImage = GalleryMedia(
//       bytes: item['data'],
//       id: item['id'],
//       dateCreated: item['created'],
//       mediaType: item['mediaType'] ?? 1,
//       path: item['path'] ?? '',
//     );
//
//     itemCache[index] = galleryImage;
//     return galleryImage;
//   }
// }

// Future<GalleryMedia> getOriginalItem(String id) async {
//   if (originalItemCache[id] != null) {
//     return await getCachedOriginalItem(id);
//   } else {
//     var channelResponse =
//         await _channel.invokeMethod("originalForGalleryItem", id);
//     var item = Map<String, dynamic>.from(channelResponse);
//
//     var galleryImage = GalleryMedia(
//       bytes: item['data'],
//       id: item['id'],
//       dateCreated: item['created'],
//       mediaType: item['mediaType'],
//       path: item['path'],
//     );
//
//     originalItemCache[id] = galleryImage;
//
//     // update();
//
//     return galleryImage;
//   }
// }

// getCachedItem(int index) {
//   return itemCache[index];
// }

// getCachedOriginalItem(String id) {
//   return originalItemCache[id];
// }

// isSelected(String id) {
//   return selectedItems.where((item) => item.id == id).isNotEmpty;
// }
//
// selectItem({required int index, required bool canSelectMultiple}) async {
//   if (mediaList.isNotEmpty) {
//     var galleryImage = mediaList[index];
//     // var galleryImage = await getOriginalItem(previewAsset.id);
//
//     if (canSelectMultiple) {
//       if (isSelected(galleryImage.id)) {
//         selectedItems.removeWhere((anItem) => anItem.id == galleryImage.id);
//         if (selectedItems.isEmpty) {
//           selectedItems.add(galleryImage);
//         }
//       } else {
//         if (selectedItems.length < 10) {
//           selectedItems.add(galleryImage);
//         }
//       }
//     } else {
//       selectedItems.clear();
//       selectedItems.add(galleryImage);
//     }
//     if (currentIndex.value >= selectedItems.length) {
//       currentIndex.value = selectedItems.length - 1;
//     }
//     update();
//   }
// }
}
