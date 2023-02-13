import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CompetitionController extends GetxController {
  RxList<CompetitionModel> current = <CompetitionModel>[].obs;
  RxList<CompetitionModel> completed = <CompetitionModel>[].obs;
  RxList<CompetitionModel> winners = <CompetitionModel>[].obs;
  RxList<CompetitionModel> allCompetitions = <CompetitionModel>[].obs;

  // late ApiResponseModel competitionResponse;
  final picker = ImagePicker();

  Rx<CompetitionModel?> competition = Rx<CompetitionModel?>(null);

  int page = 1;
  bool canLoadMoreCompetition = true;
  RxBool isLoadingCompetition = false.obs;

  clear() {
    current.clear();
    completed.clear();
    winners.clear();
    allCompetitions.clear();

    page = 1;
    canLoadMoreCompetition = true;
    isLoadingCompetition.value = false;
  }

  getCompetitions(VoidCallback callback) async {
    if (canLoadMoreCompetition) {
      await ApiController().getCompetitions(page: page).then((response) {
        allCompetitions.addAll(response.competitions);
        allCompetitions.value = allCompetitions.toSet().toList();

        current.value =
            allCompetitions.where((element) => element.isOngoing).toList();
        completed.value =
            allCompetitions.where((element) => element.isPast).toList();
        winners.value = allCompetitions
            .where((element) => element.winnerAnnounced())
            .toList();

        isLoadingCompetition.value = false;

        if (response.competitions.length == response.metaData?.perPage) {
          canLoadMoreCompetition = true;
          page += 1;
        } else {
          canLoadMoreCompetition = false;
        }
        callback();

        update();
      });
    } else {
      callback();
    }
  }

  // Future<String> loadVideoThumbnail(String videoPath) async {
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     video: videoPath,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.PNG,
  //     maxHeight: 64,
  //     // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //     quality: 75,
  //   );
  //
  //   return fileName!;
  // }

  setCompetition(CompetitionModel modal) {
    competition.value = modal;
    update();
  }

  loadCompetitionDetail({required int id}) {
    ApiController().getCompetitionsDetail(id).then((response) {
      competition.value = response.competition;
      print(
          'modal.competitionPositions ${competition.value!.competitionPositions}');

      update();
    });
  }

  void joinCompetition(CompetitionModel competition, BuildContext context) {
    int coin = getIt<UserProfileManager>().user!.coins;

    if (coin >= competition.joiningFee) {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController()
              .joinCompetition(competition.id)
              .then((response) async {
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: true);
            competition.isJoined = 1;
            update();
            getIt<UserProfileManager>().refreshProfile();
          });
        } else {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.noInternet,
              isSuccess: false);
        }
      });
    } else {
      Get.to(() =>
          EarnCoinForContestPopup(needCoins: competition.joiningFee - coin));
    }
  }

  viewMySubmission(CompetitionModel competition) async {
    var loggedInUserPost = competition.posts
        .where((element) =>
            element.user.id == getIt<UserProfileManager>().user!.id)
        .toList();
    //User have already published post for this competition
    PostModel postModel = loggedInUserPost.first;
    // File path = await AppUtil.findPath(postModel.gallery.first.filePath);

    if (competition.competitionMediaType == 1) {
      Get.to(() => EnlargeImageViewScreen(model: postModel, handler: () {}));
    } else {
      Get.to(() => PlayVideoController(
            media: postModel.gallery.first,
          ));
    }
  }

  submitMedia(CompetitionModel competition) async {
    if (competition.competitionMediaType == 1) {
      Get.to(() => SelectMedia(
            mediaType: PostMediaType.photo,
            competitionId: competition.id,
          ));
    } else {
      Get.to(() => SelectMedia(
            mediaType: PostMediaType.video,
            competitionId: competition.id,
          ));
    }
  }
}
