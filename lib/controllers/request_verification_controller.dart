import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestVerificationController extends GetxController {
  RxList<VerificationRequest> verificationRequests =
      <VerificationRequest>[].obs;

  Rx<TextEditingController> messageTf = TextEditingController().obs;
  Rx<TextEditingController> documentType = TextEditingController().obs;

  RxList<File> selectedImages = <File>[].obs;

  bool get isVerificationInProcess {
    return verificationRequests
        .where((request) => request.status == 1)
        .toList()
        .isNotEmpty;
  }

  String get verifiedOn {
    int verifiedOn = verificationRequests
        .where((request) => request.isApproved == true)
        .toList()
        .first
        .updatedAt!;

    return DateFormat('dd-MM-yyyy hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(verifiedOn * 1000));
  }

  clear() {
    documentType.value.text = '';
    messageTf.value.text = '';
    selectedImages.clear();
  }

  getVerificationRequests() {
    ApiController().getVerificationRequestHistory().then((response) {
      verificationRequests.value = response.verificationRequests;
      update();
    });
  }

  setSelectedDocumentType(String document) {
    documentType.value.text = document;
  }

  addDocument(File file) {
    selectedImages.add(file);
  }

  deleteDocument(File file) {
    selectedImages.remove(file);
  }

  submitRequest(BuildContext context) async {
    if (documentType.value.text.isEmpty) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseSelectDocumentType,
          isSuccess: false);
      return;
    }
    if (selectedImages.isEmpty) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseUploadProof,
          isSuccess: false);
      return;
    }

    List<Map<String, String>> idProofImages = [];

    EasyLoading.show(status: LocalizationString.loading);
    for (File file in selectedImages) {
      await ApiController()
          .uploadFile(file: file.path, type: UploadMediaType.verification)
          .then((response) async {
        Map<String, String> proof = {
          'filename': response.postedMediaFileName!,
          'media_type': '1',
          'title': '',
        };
        idProofImages.add(proof);
      });
    }

    ApiController()
        .sendProfileVerificationRequest(
            userMessage: messageTf.value.text,
            documentType: documentType.value.text,
            images: idProofImages)
        .then((response) {
      EasyLoading.dismiss();
      if (response.success) {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.verificationRequestSent,
            isSuccess: true);

        clear();
        Timer(const Duration(seconds: 2), () {
          Get.back();
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.errorMessage,
            isSuccess: false);
        Get.back();
      }
    });
  }

  cancelRequest(int id) {
    ApiController()
        .cancelProfileVerificationRequest(id: id, userMessage: '')
        .then((response) {
      if (response.success = true) {
        verificationRequests.removeWhere((request) => request.id == id);
        update();
      }
    });
  }
}
