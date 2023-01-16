import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EnterGroupInfoController extends GetxController {
  RxString groupImagePath = ''.obs;

  groupImageSelected(String imagePath) {
    groupImagePath.value = imagePath;
    groupImagePath.refresh();
  }

  createGroup(
      {required String name,
      required String? description,
      required String image,
      required List<UserModel> users}) {
    if (image.isEmpty) {
      publishGroup(name: name, description: description, users: users);
    } else {
      EasyLoading.show(status: LocalizationString.loading);
      ApiController()
          .uploadFile(file: image, type: UploadMediaType.chat)
          .then((response) {
        publishGroup(
            name: name,
            image: response.postedMediaFileName,
            description: description,
            users: users);
      });
    }
  }

  updateGroup(
      {required ChatRoomModel group,
      required String name,
      required String? description,
      required String image,
      required BuildContext context}) {
    if (image.isEmpty) {
      publishUpdatedGroup(
          group: group, name: name, description: description, context: context);
    } else {
      EasyLoading.show(status: LocalizationString.loading);
      ApiController()
          .uploadFile(file: image, type: UploadMediaType.chat)
          .then((response) {
        EasyLoading.dismiss();

        publishUpdatedGroup(
            group: group,
            name: name,
            image: response.postedMediaFileName,
            description: description,
            context: context);
      });
    }
  }

  publishUpdatedGroup(
      {required ChatRoomModel group,
      required String name,
      required String? description,
      String? image,
      required BuildContext context}) {
    EasyLoading.show(status: LocalizationString.loading);

    ApiController()
        .updateGroupChatRoom(group.id, name, image, description, null)
        .then((response) {
      ApiController().getChatRoomDetail(response.roomId).then((response) {
        EasyLoading.dismiss();
        Get.close(2);
        AppUtil.showToast(
            context: context,
            message: LocalizationString.groupUpdated,
            isSuccess: true);
      });
    });
  }

  publishGroup(
      {required String name,
      required String? description,
      String? image,
      required List<UserModel> users}) {
    ApiController()
        .createGroupChatRoom(name, image, description)
        .then((response) {
      String allUsersIds = users.map((e) => e.id.toString()).join(',');
      allUsersIds =
          '${getIt<UserProfileManager>().user!.id.toString()},$allUsersIds';

      getIt<SocketManager>().emit(SocketConstants.addUserInChatRoom,
          {'userId': allUsersIds, 'room': response.roomId});

      ApiController().getChatRoomDetail(response.roomId).then((response) {
        EasyLoading.dismiss();
        if (response.room != null) {
          Get.close(2);

          Get.to(() => ChatDetail(chatRoom: response.room!));

          // save group in local storage
          getIt<DBManager>().saveRooms([response.room!]);
        } else {
          Get.back();
        }
      });
    });
  }
}
