import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../model/get_relationship_model.dart';
import '../model/myRelations/my_invitation_model.dart';
import '../model/myRelations/my_relations_model.dart';

class RelationshipController extends GetxController {
  RxList<RelationshipName> relationshipNames = <RelationshipName>[].obs;

  // RxList<MyRelationsModel> myRelationships = <MyRelationsModel>[].obs;
  RxList<MyInvitationsModel> myInvitations = <MyInvitationsModel>[].obs;
  RxList<MyRelationsModel> relationships = <MyRelationsModel>[].obs;

  final ProfileController _profileController = Get.find();

  clear() {
    print('clear');
    relationshipNames.clear();
    myInvitations.clear();
    relationships.clear();
  }

  getRelationships() {
    ApiController().getRelationships().then((response) {
      relationshipNames.value = response.relationshipNames.toList();
      relationshipNames.refresh();

      update();
    });
  }

  getUsersRelationships({required int userId}) {
    ApiController().getUsersRelationships(userId).then((response) {
      relationships.value = response.relationships.toList();
      relationships.refresh();
      update();
    });
  }

  getMyRelationships() {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().getMyRelations().then((response) {
      relationships.value = response.relationships.toList();
      relationships.refresh();
      EasyLoading.dismiss();
      update();
    });
  }

  getMyInvitations() {
    ApiController().getMyInvitations().then((response) {
      myInvitations.value = response.myInvitations.toList();
      myInvitations.refresh();
      update();
    });
  }

  acceptRejectInvitation(int invitationId, int status, VoidCallback handler) {
    update();
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().acceptRejectInvitation(invitationId, status).then((value) {
      handler();
      EasyLoading.dismiss();
    });
  }

  postRelationshipSettings(int relationSetting) {
    update();
    EasyLoading.show(status: LocalizationString.loading);
    ApiController()
        .postRelationshipSettings(relationSetting)
        .then((value) async {
      await _profileController.getMyProfile();
      update();
      EasyLoading.dismiss();
    });
  }
}
