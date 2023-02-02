import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../model/get_relationship_model.dart';
import '../model/myRelations/my_invitation_model.dart';
import '../model/myRelations/my_relations_model.dart';

class RelationshipController extends GetxController {
  RxList<GetRelationshipModel> relationship = <GetRelationshipModel>[].obs;
  RxList<MyRelationsModel> myRelationships = <MyRelationsModel>[].obs;
  RxList<MyInvitationsModel> myInvitations = <MyInvitationsModel>[].obs;

  // clearCategories() {
  //   categories.clear();
  //   update();
  // }


  getRelationships() {
    ApiController().getRelationships().then((response) {
      relationship.value = response.relationships
          .toList();
      relationship.refresh();
      update();
    });
  }

  getMyRelationships() {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController().getMyRelations().then((response) {
      myRelationships.value = response.myRelationships
          .toList();
      myRelationships.refresh();
      EasyLoading.dismiss();
      update();
    });
  }

  getMyInvitations(VoidCallback handler) {
    ApiController().getMyInvitations().then((response) {
      myInvitations.value = response.myInvitations
          .toList();
      myInvitations.refresh();
      update();
      handler();
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


}
