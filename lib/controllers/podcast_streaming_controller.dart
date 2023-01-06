import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import '../model/podcast_banner_model.dart';
import '../model/podcast_model.dart';

class PodcastStreamingController extends GetxController {
  RxList<PodcastBannerModel> banners = <PodcastBannerModel>[].obs;
  RxList<PodcastCategoryModel> categories = <PodcastCategoryModel>[].obs;
  RxList<PodcastModel> podcasts = <PodcastModel>[].obs;
  RxList<PodcastShowModel> podcastShows = <PodcastShowModel>[].obs;
  RxList<PodcastShowSongModel> podcastShowEpisodes =
      <PodcastShowSongModel>[].obs;

  clearCategories() {
    categories.clear();
    update();
  }

  clearBanners() {
    banners.clear();
    update();
  }

  clearPodcast() {
    podcasts.clear();
    update();
  }

  getPodcastCategories() {
    ApiController().getPodcastCategories().then((response) {
      categories.value = response.podcastCategories
          .where((element) => element.podcasts.isNotEmpty)
          .toList();
      categories.refresh();
      update();
    });
  }

  getPodcastBanners() {
    ApiController().getPodcastBanners().then((response) {
      banners.value = response.podcastBanners;
      update();
    });
  }

  getPodCastList({int? categoryId, String? name}) {
    ApiController()
        .getPodcastList(categoryId: categoryId, name: name)
        .then((response) {
      podcasts.value = response.podcasts;
      update();
    });
  }

  getPodcastShows({int? podcastId, String? name}) {
    ApiController()
        .getPodcastShows(podcastId: podcastId, name: name)
        .then((response) {
      podcastShows.value = response.podcastShows;
      podcastShows.refresh();
      update();
    });
  }

  getPodcastShowsEpisode(
      {int? podcastShowId, String? name}) async {
    return ApiController()
        .getPodcastShowsEpisode(podcastShowId: podcastShowId, name: name)
        .then((response) {
      podcastShowEpisodes.value = response.podcastShowSongs;
      podcastShowEpisodes.refresh();
      update();
    });
  }

  // subscribeTv(TvModel tvModel, Function(bool) completionCallBack) {
  //   if (getIt<UserProfileManager>().user!.coins >=
  //       tvModel.coinsNeededToUnlock) {
  //     ApiController().subscribeTv(tvModel: tvModel).then((response) {
  //       completionCallBack(response.success);
  //     });
  //   } else {
  //     Get.to(() => const PackagesScreen());
  //   }
  // }

  // stopWatchingTv(TvModel tvModel, Function(bool) completionCallBack) {
  //   ApiController().stopWatchingTv(tvModel: tvModel).then((response) {
  //     completionCallBack(response.success);
  //   });
  // }

  // joinTv(int id) {
  //   var liveTvId = 'tv_$id';
  //
  //   var message = {
  //     'userId': getIt<UserProfileManager>().user!.id,
  //     'liveTvId': liveTvId,
  //   };
  //
  //   getIt<SocketManager>().emit(SocketConstants.joinLiveTv, message);
  // }
}
