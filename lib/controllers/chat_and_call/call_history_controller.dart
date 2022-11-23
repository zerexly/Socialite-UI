import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CallHistoryController extends GetxController {
  RxList<CallHistoryModel> calls = <CallHistoryModel>[].obs;
  final AgoraCallController agoraCallController = Get.find();

  int callHistoryPage = 1;
  bool canLoadMoreCalls = true;
  bool isLoading = false;

  clear() {
    isLoading = false;
    calls.value = [];
    callHistoryPage = 1;
    canLoadMoreCalls = true;
  }

  callHistory() {
    if (canLoadMoreCalls) {
      isLoading = true;
      ApiController().getCallHistory(page: callHistoryPage).then((response) {
        calls.addAll(response.callHistory);
        isLoading = false;

        callHistoryPage += 1;
        if (response.callHistory.length == response.metaData?.perPage) {
          canLoadMoreCalls = true;
        } else {
          canLoadMoreCalls = false;
        }
        update();
      });
    }
  }

  void reInitiateCall(
      {required CallHistoryModel call, required BuildContext context}) {
    if (call.callType == 1) {
      initiateAudioCall(context: context, opponent: call.opponent);
    } else {
      initiateVideoCall(context: context, opponent: call.opponent);
    }
  }

  void initiateVideoCall(
      {required BuildContext context, required UserModel opponent}) {
    PermissionUtils.requestPermission(
        [Permission.camera, Permission.microphone], context,
        isOpenSettings: false, permissionGrant: () async {
      Call call = Call(
          uuid: '',
          callId: 0,
          channelName: '',
          token: '',
          isOutGoing: true,
          callType: 2,
          opponent: opponent);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToCameraForVideoCall,
          isSuccess: false);

    }, permissionNotAskAgain: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToCameraForVideoCall,
          isSuccess: false);

    });
  }

  void initiateAudioCall(
      {required BuildContext context, required UserModel opponent}) {
    PermissionUtils.requestPermission([Permission.microphone], context,
        isOpenSettings: false, permissionGrant: () async {
      Call call = Call(
          uuid: '',
          callId: 0,
          channelName: '',
          token: '',
          isOutGoing: true,
          callType: 1,
          opponent: opponent);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.pleaseAllowAccessToMicrophoneForAudioCall,
              isSuccess: false);

        }, permissionNotAskAgain: () {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.pleaseAllowAccessToMicrophoneForAudioCall,
              isSuccess: false);

        });
  }
}
