import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../model/club_invitation.dart';

class ClubsController extends GetxController {
  RxList<ClubModel> clubs = <ClubModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ClubMemberModel> members = <ClubMemberModel>[].obs;
  RxList<ClubInvitation> invitations = <ClubInvitation>[].obs;

  RxBool isLoadingCategories = false.obs;

  int clubsPage = 1;
  bool canLoadMoreClubs = true;
  RxBool isLoadingClubs = false.obs;

  int invitationsPage = 1;
  bool canLoadMoreInvitations = true;
  RxBool isLoadingInvitations = false.obs;

  int membersPage = 1;
  bool canLoadMoreMembers = true;
  bool isLoadingMembers = false;

  RxInt segmentIndex = (-1).obs;

  clear() {
    isLoadingClubs.value = false;
    clubs.clear();
    clubsPage = 1;
    canLoadMoreClubs = true;

    invitationsPage = 1;
    canLoadMoreInvitations = true;
    isLoadingInvitations.value = false;
    invitations.clear();

    segmentIndex.value = 0;
  }

  clearMembers() {
    isLoadingMembers = false;
    members.value = [];
    membersPage = 1;
    canLoadMoreMembers = true;
  }

  selectedSegmentIndex(int index) {
    if (isLoadingClubs.value == true) {
      return;
    }
    update();

    if (index == 0 && segmentIndex.value != index) {
      clear();
      getClubs();
    } else if (index == 1 && segmentIndex.value != index) {
      clear();
      getClubs(isJoined: 1);
    } else if (index == 2 && segmentIndex.value != index) {
      clear();
      getClubs(userId: getIt<UserProfileManager>().user!.id);
    } else if (index == 3 && segmentIndex.value != index) {
      getClubInvitations();
    }

    segmentIndex.value = index;
  }

  getClubs({String? name, int? categoryId, int? userId, int? isJoined}) {
    if (canLoadMoreClubs) {
      isLoadingClubs.value = true;
      ApiController()
          .getClubs(
              name: name,
              categoryId: categoryId,
              userId: userId,
              isJoined: isJoined,
              page: clubsPage)
          .then((response) {
        clubs.addAll(response.clubs);
        isLoadingClubs.value = false;

        clubsPage += 1;
        if (response.clubs.length == response.metaData?.perPage) {
          canLoadMoreClubs = true;
        } else {
          canLoadMoreClubs = false;
        }
        update();
      });
    }
  }

  getClubInvitations() {
    if (canLoadMoreInvitations) {
      isLoadingInvitations.value = true;
      ApiController()
          .getClubInvitations(page: invitationsPage)
          .then((response) {
        invitations.addAll(response.clubInvitations);
        isLoadingInvitations.value = false;

        invitationsPage += 1;
        if (response.clubInvitations.length == response.metaData?.perPage) {
          canLoadMoreInvitations = true;
        } else {
          canLoadMoreInvitations = false;
        }
        update();
      });
    }
  }

  clubDeleted(ClubModel club) {
    clubs.removeWhere((element) => element.id == club.id);
    clubs.refresh();
  }

  getMembers({int? clubId}) {
    if (canLoadMoreMembers) {
      isLoadingMembers = true;
      ApiController()
          .getClubMembers(clubId: clubId, page: membersPage)
          .then((response) {
        members.addAll(response.clubMembers);
        isLoadingMembers = false;

        membersPage += 1;
        if (response.clubMembers.length == response.metaData?.perPage) {
          canLoadMoreMembers = true;
        } else {
          canLoadMoreMembers = false;
        }
        update();
      });
    }
  }

  getCategories() {
    isLoadingCategories.value = true;
    ApiController().getClubCategories().then((response) {
      categories.value = response.categories;
      isLoadingCategories.value = false;

      update();
    });
  }

  joinClub(ClubModel club) {
    if (club.isRequestBased == true) {
      clubs.value = clubs.map((element) {
        if (element.id == club.id) {
          element.isRequested = true;
        }
        return element;
      }).toList();

      clubs.refresh();

      ApiController().sendClubJoinRequest(clubId: club.id!).then((response) {});
    } else {
      clubs.value = clubs.map((element) {
        if (element.id == club.id) {
          element.isJoined = true;
        }
        return element;
      }).toList();

      clubs.refresh();

      ApiController().joinClub(clubId: club.id!).then((response) {});
    }
  }

  leaveClub(ClubModel club) {
    clubs.value = clubs.map((element) {
      if (element.id == club.id) {
        element.isJoined = false;
      }
      return element;
    }).toList();

    clubs.refresh();
    ApiController().leaveClub(clubId: club.id!).then((response) {});
  }

  acceptClubInvitation(ClubInvitation invitation) {
    invitations.remove(invitation);
    invitations.refresh();
    ApiController()
        .acceptDeclineClubInvitation(
            invitationId: invitation.id!, replyStatus: 10)
        .then((response) {});
  }

  declineClubInvitation(ClubInvitation invitation) {
    invitations.remove(invitation);
    invitations.refresh();
    ApiController()
        .acceptDeclineClubInvitation(
            invitationId: invitation.id!, replyStatus: 3)
        .then((response) {});
  }

  removeMemberFromClub(ClubModel club, ClubMemberModel member) {
    members.remove(member);
    update();

    ApiController()
        .removeMemberFromClub(clubId: club.id!, userId: member.id)
        .then((response) {});
  }

  deleteClub({required ClubModel club, required VoidCallback callback}) {
    EasyLoading.show(status: LocalizationString.loading);

    ApiController()
        .deleteClub(
      club.id!,
    )
        .then((response) {
      EasyLoading.dismiss();
      Get.back();
      callback();
    });
  }
}
