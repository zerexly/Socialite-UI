import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubDetail extends StatefulWidget {
  final ClubModel club;
  final VoidCallback needRefreshCallback;
  final Function(ClubModel) deleteCallback;

  const ClubDetail(
      {Key? key,
      required this.club,
      required this.needRefreshCallback,
      required this.deleteCallback})
      : super(key: key);

  @override
  ClubDetailState createState() => ClubDetailState();
}

class ClubDetailState extends State<ClubDetail> {
  final ClubDetailController _clubDetailController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final _controller = ScrollController();

  @override
  void initState() {
    _clubDetailController.setEvent(widget.club);
    refreshPosts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _clubDetailController.clear();
  }

  refreshPosts() {
    _clubDetailController.getPosts(
        clubId: widget.club.id!,
        callback: () {
          _refreshController.refreshCompleted();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                          height: 250,
                          child: CachedNetworkImage(
                            imageUrl: _clubDetailController.club.value!.image!,
                            fit: BoxFit.cover,
                          )
                          // CachedNetworkImage(

                          ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(_clubDetailController.club.value!.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w600))
                          .hP16,
                      const SizedBox(
                        height: 20,
                      ),
                      Text(_clubDetailController.club.value!.desc!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w200))
                          .hP16,
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const ThemeIconWidget(ThemeIcon.userGroup),
                          // Text(
                          //   'Public group',
                          //   style: Theme.of(context).textTheme.titleMedium,
                          // ).hP8,
                          Text(
                            '${_clubDetailController.club.value!.totalMembers!.formatNumber} ${LocalizationString.clubMembers}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          ).hP8.ripple(() {
                            Get.to(() => ClubMembers(
                                club: _clubDetailController.club.value!));
                          })
                        ],
                      ).hP16,
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _clubDetailController.club.value!.createdByUser!.isMe
                              ? SizedBox(
                                  height: 50,
                                  width: _clubDetailController
                                              .club.value!.enableChat ==
                                          1
                                      ? (MediaQuery.of(context).size.width -
                                              32) *
                                          0.7
                                      : (MediaQuery.of(context).size.width -
                                          32),
                                  child: FilledButtonType1(
                                      text: LocalizationString.post,
                                      onPress: () {
                                        Get.to(() => SelectMedia(
                                              clubId: _clubDetailController
                                                  .club.value!.id!,
                                            ));
                                      }))
                              : SizedBox(
                                  height: 50,
                                  width: _clubDetailController
                                                  .club.value!.enableChat ==
                                              1 &&
                                          _clubDetailController
                                                  .club.value!.isJoined ==
                                              true
                                      ? (MediaQuery.of(context).size.width -
                                              32) *
                                          0.7
                                      : (MediaQuery.of(context).size.width -
                                          32),
                                  child: FilledButtonType1(
                                      text: _clubDetailController
                                                  .club.value!.isJoined ==
                                              true
                                          ? LocalizationString.leaveClub
                                          : LocalizationString.join,
                                      onPress: () {
                                        if (_clubDetailController
                                                .club.value!.isJoined ==
                                            true) {
                                          _clubDetailController.leaveClub();
                                        } else {
                                          _clubDetailController.joinClub();
                                        }
                                      })),
                          if (_clubDetailController.club.value!.enableChat ==
                                  1 &&
                              _clubDetailController.club.value!.isJoined ==
                                  true)
                            SizedBox(
                                height: 50,
                                width:
                                    (MediaQuery.of(context).size.width - 32) *
                                        0.25,
                                child: FilledButtonType1(
                                    enabledBackgroundColor:
                                        Theme.of(context).cardColor.lighten(),
                                    text: LocalizationString.chat,
                                    onPress: () {
                                      EasyLoading.show(
                                          status: LocalizationString.loading);
                                      _chatDetailController.getRoomDetail(
                                          _clubDetailController
                                              .club.value!.chatRoomId!, (room) {
                                        EasyLoading.dismiss();
                                        Get.to(
                                            () => ChatDetail(chatRoom: room));
                                      });
                                    }))
                        ],
                      ).p16,
                    ],
                  );
                }),
                Obx(() => SizedBox(
                      height: (_clubDetailController.posts.length * 500) +
                          (_clubDetailController.posts.length * 40),
                      child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, index) {
                            return PostCard(
                              model: _clubDetailController.posts[index],
                              textTapHandler: (text) {},
                              // likeTapHandler: () {},
                              removePostHandler: () {},
                              // mediaTapHandler: (post){
                              //   Get.to(()=> PostMediaFullScreen(post: post));
                              // },
                            );
                          },
                          separatorBuilder: (BuildContext context, index) {
                            return const SizedBox(
                              height: 40,
                            );
                          },
                          itemCount: _clubDetailController.posts.length),
                    ).vP16)
              ]))
            ],
          ),
          appBar()
        ],
      ),
    );
  }

  Widget appBar() {
    return Positioned(
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.5),
                  Colors.grey.withOpacity(0.0),
                ],
                stops: const [
                  0.0,
                  0.5,
                  1.0
                ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 20,
              color: Colors.white,
            ).ripple(() {
              Get.back();
            }),
            Obx(() => Text(
                  _clubDetailController.club.value!.name!,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.white),
                )),
            widget.club.amIAdmin
                ? const ThemeIconWidget(
                    ThemeIcon.setting,
                    size: 20,
                    color: Colors.white,
                  ).ripple(() {
                    Get.to(() => ClubSettings(
                          club: widget.club,
                          updateClubCallback: (club) {
                            _clubDetailController.setEvent(club);
                          },
                          deleteClubCallback: (club) {
                            Get.back();
                            widget.deleteCallback(club);
                          },
                        ));
                  })
                : const SizedBox(
                    width: 20,
                  )
          ],
        ).hP16,
      ),
    );
  }

  postsView() {
    return Obx(() {
      return ListView.separated(
              controller: _controller,
              padding: const EdgeInsets.only(top: 20, bottom: 100),
              itemCount: _clubDetailController.posts.length,
              itemBuilder: (context, index) {
                PostModel model = _clubDetailController.posts[index - 3];

                return PostCard(
                  model: model,
                  textTapHandler: (text) {
                    _clubDetailController.postTextTapHandler(
                        post: model, text: text);
                  },
                  removePostHandler: () {
                    _clubDetailController.removePostFromList(model);
                  },
                  // mediaTapHandler: (post){
                  //   Get.to(()=> PostMediaFullScreen(post: post));
                  // },
                );
              },
              separatorBuilder: (context, index) {
                if (index == 1) {
                  return Container();
                } else {
                  return const SizedBox(
                    height: 20,
                  );
                }
              })
          .addPullToRefresh(
              refreshController: _refreshController,
              enablePullUp: false,
              onRefresh: refreshPosts,
              onLoading: () {});
    });
  }

  showActionSheet(PostModel post) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet1(
              items: [
                GenericItem(
                    id: '1',
                    title: LocalizationString.share,
                    icon: ThemeIcon.share),
                GenericItem(
                    id: '2',
                    title: LocalizationString.report,
                    icon: ThemeIcon.report),
                GenericItem(
                    id: '3',
                    title: LocalizationString.hide,
                    icon: ThemeIcon.hide),
              ],
              itemCallBack: (item) {},
            ));
  }
}
