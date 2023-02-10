import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EnterGroupInfoController extends GetxController {
  final ChatHistoryController _chatHistoryController = Get.find();
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
    EasyLoading.show(
        status: LocalizationString.loading,
        maskType: EasyLoadingMaskType.black);

    if (image.isEmpty) {
      publishGroup(name: name, description: description, users: users);
    } else {
      // EasyLoading.show(status: LocalizationString.loading);
      ApiController()
          .uploadFile(file: image, type: UploadMediaType.chat)
          .then((response) {
        if (response.success) {
          publishGroup(
              name: name,
              image: response.postedMediaFileName,
              description: description,
              users: users);
        } else {
          AppUtil.showToast(
              context: Get.context!,
              message: response.message,
              isSuccess: false);
        }
      });
    }
  }

  updateGroup(
      {required ChatRoomModel group,
      required String name,
      required String? description,
      required String image,
      required BuildContext context}) {
    EasyLoading.show(
        status: LocalizationString.loading,
        maskType: EasyLoadingMaskType.black);

    if (image.isEmpty) {
      publishUpdatedGroup(
          group: group, name: name, description: description, context: context);
    } else {
      ApiController()
          .uploadFile(file: image, type: UploadMediaType.chat)
          .then((response) {
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
    ApiController()
        .updateGroupChatRoom(group.id, name, image, description, null)
        .then((response) {
      if (response.success) {
        EasyLoading.dismiss();
        Get.close(2);
        // ApiController().getChatRoomDetail(response.roomId).then((response) {
        //   EasyLoading.dismiss();
        //   Get.close(2);
        //   AppUtil.showToast(
        //       context: context,
        //       message: LocalizationString.groupUpdated,
        //       isSuccess: true);
        //
        //   // print('3');
        //   // getIt<DBManager>().updateRoom(response.room!);
        // });
      } else {
        AppUtil.showToast(
            context: context, message: response.message, isSuccess: false);
      }
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

      ApiController().getChatRoomDetail(response.roomId).then((response) async {
        EasyLoading.dismiss();
        if (response.room != null) {
          Get.close(2);
          Get.to(() => ChatDetail(chatRoom: response.room!));

          // save group in local storage
          await getIt<DBManager>().saveRooms([response.room!]);

          _chatHistoryController.getChatRooms();
        } else {
          Get.back();
        }
      });
    });
  }
}
