import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PodcastStreamingController extends GetxController {
  RxList<PodcastBannerModel> banners = <PodcastBannerModel>[].obs;
  RxList<PodcastCategoryModel> categories = <PodcastCategoryModel>[].obs;
  RxList<PodcastModel> podcasts = <PodcastModel>[].obs;
  RxList<PodcastShowModel> podcastShows = <PodcastShowModel>[].obs;
  RxList<PodcastShowEpisodeModel> podcastShowEpisodes =
      <PodcastShowEpisodeModel>[].obs;

  Rx<PodcastShowModel?> showDetail = Rx<PodcastShowModel?>(null);
  Rx<PodcastModel?> hostDetail = Rx<PodcastModel?>(null);

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

  getPodcastShowsEpisode({int? podcastShowId, String? name}) async {
    return ApiController()
        .getPodcastShowsEpisode(podcastShowId: podcastShowId, name: name)
        .then((response) {
      podcastShowEpisodes.value = response.podcastShowEpisodes;
      podcastShowEpisodes.refresh();
      update();
    });
  }

  getPodcastShowById(int showId, Function() completionCallBack) {
    ApiController().getPodcastShowById(showId: showId).then((response) {
      showDetail.value = response.podcastShowDetail;
      update();
      completionCallBack();
    });
  }

  getHostById(int hostId, Function() completionCallBack) {
    ApiController().getPodcastHostById(hostId: hostId).then((response) {
      hostDetail.value = response.podcastHostDetail;
      update();
      completionCallBack();
    });
  }
}
