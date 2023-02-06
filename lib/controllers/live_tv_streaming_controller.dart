import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import 'package:foap/model/live_tv_model.dart';
import '../model/tv_show_model.dart';

class TvStreamingController extends GetxController {
  RxInt currentPage = 0.obs;
  RxMap<String, List<ChatMessageModel>> messagesMap =
      <String, List<ChatMessageModel>>{}.obs;

  RxBool showChatMessages = false.obs;
  RxList<TVBannersModel> banners = <TVBannersModel>[].obs;
  RxList<TvModel> tvs = <TvModel>[].obs;
  RxList<TvCategoryModel> categories = <TvCategoryModel>[].obs;
  RxList<TVShowModel> tvShows = <TVShowModel>[].obs;
  RxList<TVShowEpisodeModel> tvEpisodes = <TVShowEpisodeModel>[].obs;
  Rx<TvModel?> currentViewingTv = Rx<TvModel?>(null);

  RxInt currentBannerIndex = 0.obs;
  Rx<TVShowEpisodeModel?> selectedEpisode = Rx<TVShowEpisodeModel?>(null);

  RxInt currentSegment = (0).obs;
  Rx<TVShowModel?> showDetail = Rx<TVShowModel?>(null);
  Rx<TvModel?> tvChannelDetail = Rx<TvModel?>(null);

  RxBool showTopBar = true.obs;

  bool isLoadingFavTvs = false;
  int favTvsCurrentPage = 1;
  bool canLoadMoreFavTvs = true;

  bool isLoadingSubscribedTvs = false;
  int subscribedTvsCurrentPage = 1;
  bool canLoadMoreSubscribedTvs = true;

  clearCategories() {
    categories.clear();
    update();
  }

  clearTvs() {
    tvs.clear();
    currentViewingTv.value = null;

    // isLoadingLiveTvs = false;
    // liveTvsCurrentPage = 1;
    // canLoadMoreLiveTvs = true;

    isLoadingFavTvs = false;
    favTvsCurrentPage = 1;
    canLoadMoreFavTvs = true;

    isLoadingSubscribedTvs = false;
    subscribedTvsCurrentPage = 1;
    canLoadMoreSubscribedTvs = true;

    // isLoadingSearchedLiveTvs = false;
    // searchedLiveTvsCurrentPage = 1;
    // canLoadMoreSearchedLiveTvs = true;

    // update();
  }

  setCurrentViewingTv(TvModel tvModel) {
    currentViewingTv.value = tvModel;
    update();
  }

  segmentChanged(int segment) {
    currentSegment.value = segment;
  }

  updateBannerSlider(int index) {
    currentBannerIndex.value = index;
  }

  toggleTopBar() {
    showTopBar.value = !showTopBar.value;
  }

  getTvCategories() {
    ApiController().getTVCategories().then((response) {
      categories.value = response.tvCategories
          .where((element) => element.tvs.isNotEmpty)
          .toList();
      categories.refresh();
      update();
    });
  }

  getTvBanners() {
    ApiController().getTvBanners().then((response) {
      banners.value = response.tvBanners;
      update();
    });
  }

  getLiveTv() {
    ApiController().getTvs(isLive: true).then((response) {
      tvs.value = response.tvs;
      update();
    });
  }

  getTvs({int? categoryId, String? name}) {
    ApiController().getTvs(categoryId: categoryId, name: name).then((response) {
      tvs.value = response.tvs;
      update();
    });
  }

  getFavTvs() {
    if (canLoadMoreFavTvs == true) {
      isLoadingFavTvs = true;

      ApiController().getFavLiveTvs().then((response) {
        tvs.addAll(response.tvs);

        isLoadingFavTvs = false;
        favTvsCurrentPage += 1;

        if (response.tvs.length == response.metaData?.pageCount) {
          canLoadMoreFavTvs = true;
        } else {
          canLoadMoreFavTvs = false;
        }
        update();
      });
    }
  }

  getSubscribedTvs() {
    if (canLoadMoreSubscribedTvs == true) {
      isLoadingSubscribedTvs = true;

      ApiController().getSubscribedLiveTvs().then((response) {
        tvs.addAll(response.tvs);

        isLoadingSubscribedTvs = false;
        subscribedTvsCurrentPage += 1;

        if (response.tvs.length == response.metaData?.pageCount) {
          canLoadMoreSubscribedTvs = true;
          // totalPages = response.metaData!.pageCount;
        } else {
          canLoadMoreSubscribedTvs = false;
        }
        update();
      });
    }
  }

  getTvShows({int? liveTvId, String? name}) {
    ApiController().getTVShows(liveTvId: liveTvId, name: name).then((response) {
      tvShows.value = response.tvShows;
      tvShows.refresh();
      update();
    });
  }

  getTvShowById(int showId, Function() completionCallBack) {
    ApiController().getTVShowById(showId: showId).then((response) {
      showDetail.value = response.tvShowDetail;
      update();
      completionCallBack();
    });
  }

  getTvChannelById(int tvId, Function() completionCallBack) {
    ApiController().getTVChannelById(tvId: tvId).then((response) {
      tvChannelDetail.value = response.tvChannelDetail;
      update();
      completionCallBack();
    });
  }

  getTvShowEpisodes({int? showId, String? name}) {
    ApiController()
        .getTVShowEpisodes(showId: showId, name: name)
        .then((response) {
      tvEpisodes.value = response.tvEpisodes;
      tvEpisodes.refresh();
      playEpisode(tvEpisodes.first);
      update();
    });
  }

  playEpisode(TVShowEpisodeModel episode) {
    selectedEpisode.value = episode;
    selectedEpisode.refresh();
  }

  subscribeTv(TvModel tvModel, Function(bool) completionCallBack) {
    getTvChannelById(tvModel.id, () {
      if (getIt<UserProfileManager>().user!.coins >=
          tvChannelDetail.value!.coinsNeededToUnlock) {
        ApiController().subscribeTv(tvModel: tvModel).then((response) {
          completionCallBack(response.success);
        });
      } else {
        Get.to(() => const PackagesScreen());
      }
    });
  }

  stopWatchingTv(TvModel tvModel, Function(bool) completionCallBack) {
    ApiController().stopWatchingTv(tvModel: tvModel).then((response) {
      completionCallBack(response.success);
    });
  }

  joinTv(int id) {
    var liveTvId = 'tv_$id';

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'liveTvId': liveTvId,
    };

    getIt<SocketManager>().emit(SocketConstants.joinLiveTv, message);
  }

  favUnfavTv(TvModel tv) {
    currentViewingTv.value?.isFav = tv.isFav == 1 ? 0 : 1;
    tv.isFav = currentViewingTv.value!.isFav;

    currentViewingTv.refresh();

    categories.value = categories.map((category) {
      var tvs = category.tvs.map((currentTvInIteration) {
        if (tv.id == currentTvInIteration.id) {
          currentTvInIteration.isFav = tv.isFav;
        }
        return currentTvInIteration;
      }).toList();
      category.tvs = tvs;
      return category;
    }).toList();
    print(categories.map((element) => element.id));

    tvs.value = tvs.map((currentTvInIteration) {
      if (tv.id == currentTvInIteration.id) {
        currentTvInIteration.isFav = tv.isFav;
      }
      return currentTvInIteration;
    }).toList();

    // update();

    ApiController()
        .likeUnlikeTv(currentViewingTv.value?.isFav == 1 ? true : false,
        currentViewingTv.value!.id)
        .then((response) {});
  }

  hideMessagesView() {
    showChatMessages.value = false;
    showChatMessages.refresh();
  }

  showMessagesView() {
    showChatMessages.value = true;
    showChatMessages.refresh();
  }

  // currentPageChanged(int index) {
  //   currentPage.value = index;
  //   currentPage.refresh();
  // }

  newMessageReceived(ChatMessageModel message) {
    addNewMessage(message, int.parse(message.liveTvId.split('_').last));
  }

  sendTextMessage(String messageText, int id) {
    String localMessageId = randomId();
    var liveTvId = 'tv_$id';
    String encrtyptedMessage = messageText; //.encrypted();

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'liveTvId': liveTvId,
      'local_message_id': localMessageId,
      'messageType': messageTypeId(MessageContentType.text),
      'message': encrtyptedMessage,
      'picture': getIt<UserProfileManager>().user!.picture,
      'username': getIt<UserProfileManager>().user!.userName,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    getIt<SocketManager>().emit(SocketConstants.sendMessageInLiveTv, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = id;
    localMessageModel.userName = LocalizationString.you;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.text);
    localMessageModel.messageContent = messageText;

    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    addNewMessage(localMessageModel, id);
  }

  addNewMessage(ChatMessageModel message, int tvId) {
    List<ChatMessageModel> messages = (messagesMap[tvId.toString()] ?? []);

    messages.add(message);
    messagesMap[tvId.toString()] = messages;
    messagesMap.refresh();
    update();
  }
}
