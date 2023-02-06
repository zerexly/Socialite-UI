import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  final PostModel model;
  final Function(String) textTapHandler;

  final VoidCallback removePostHandler;

  const PostCard(
      {Key? key,
      required this.model,
      required this.textTapHandler,
      required this.removePostHandler})
      : super(key: key);

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  final HomeController homeController = Get.find();
  final PostCardController postCardController = Get.find();
  final ChatDetailController chatDetailController = Get.find();
  final SelectUserForChatController selectUserForChatController = Get.find();
  final FlareControls flareControls = FlareControls();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      addPostUserInfo().hP8,
      GestureDetector(
          onDoubleTap: () {
            //   widget.model.isLike = !widget.model.isLike;
            postCardController.likeUnlikePost(
                post: widget.model, context: context);
            flareControls.play("like");
          },
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    PostMediaFullScreen(post: widget.model),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );

            // widget.mediaTapHandler(widget.model);
          },
          child: Stack(
            children: [
              mediaTile(),
              Obx(() => Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: FlareActor(
                              'assets/like.flr',
                              controller: flareControls,
                              animation: 'idle',
                              color: postCardController.likedPosts
                                          .contains(widget.model) ||
                                      widget.model.isLike
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        )),
                  ))
            ],
          )),
      commentAndLikeWidget().hP16,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          DetectableText(
            text: widget.model.title,
            detectionRegExp: RegExp(
              "(?!\\n)(?:^|\\s)([#@]([$detectionContentLetters]+))|$urlRegexContent",
              multiLine: true,
            ),
            detectedStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600),
            basicStyle: Theme.of(context).textTheme.bodyMedium,
            onTap: (tappedText) {
              widget.textTapHandler(tappedText);
              // postCardController.titleTextTapped(text: tappedText,post: widget.model);
            },
          ),
        ],
      ).hP16
    ]).vP16.shadow(context: context, radius: 10, shadowOpacity: 0.05).hP16;
  }

  Widget mediaTile() {
    if (widget.model.gallery.length > 1) {
      return SizedBox(
        height: 350,
        child: Stack(
          children: [
            CarouselSlider(
              items: mediaList(),
              options: CarouselOptions(
                aspectRatio: 1,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                height: double.infinity,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  postCardController.updateGallerySlider(
                      index, widget.model.id);
                },
              ),
            ),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () {
                      return DotsIndicator(
                        dotsCount: widget.model.gallery.length,
                        position: (postCardController
                                    .postScrollIndexMapping[widget.model.id] ??
                                0)
                            .toDouble(),
                        decorator: DotsDecorator(
                            activeColor: Theme.of(context).primaryColor),
                      );
                    },
                  ),
                ))
          ],
        ).vP16,
      );
    } else {
      return widget.model.gallery.first.isVideoPost == true
          ? videoPostTile(widget.model.gallery.first).vP16
          : SizedBox(
              height: 350,
              child: photoPostTile(widget.model.gallery.first).vP16);
    }
  }

  List<Widget> mediaList() {
    return widget.model.gallery.map((item) {
      if (item.isVideoPost == true) {
        return videoPostTile(item);
      } else {
        return photoPostTile(item);
      }
    }).toList();
  }

  Widget commentAndLikeWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      InkWell(
          onTap: () => openComments(),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ThemeIconWidget(
              ThemeIcon.message,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              width: 5,
            ),
            widget.model.totalComment > 0
                ? Text('${widget.model.totalComment}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w900))
                    .ripple(() {
                    openComments();
                  })
                : Container(),
          ])),
      const SizedBox(
        width: 10,
      ),
      Obx(() => InkWell(
          onTap: () {
            postCardController.likeUnlikePost(
                post: widget.model, context: context);
            // widget.likeTapHandler();
          },
          child: ThemeIconWidget(
            postCardController.likedPosts.contains(widget.model) ||
                    widget.model.isLike
                ? ThemeIcon.favFilled
                : ThemeIcon.fav,
            color: postCardController.likedPosts.contains(widget.model) ||
                    widget.model.isLike
                ? Theme.of(context).errorColor
                : Theme.of(context).iconTheme.color,
          ))),
      const SizedBox(
        width: 5,
      ),
      Obx(() {
        int totalLikes = 0;
        if (postCardController.likedPosts.contains(widget.model)) {
          PostModel post = postCardController.likedPosts
              .where((e) => e.id == widget.model.id)
              .first;
          totalLikes = post.totalLike;
        } else {
          totalLikes = widget.model.totalLike;
        }
        return totalLikes > 0
            ? Text('${widget.model.totalLike}',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900))
            : Container();
      }),
      const SizedBox(
        width: 10,
      ),
      ThemeIconWidget(
        ThemeIcon.share,
        color: Theme.of(context).iconTheme.color,
      ).ripple(() {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => SelectFollowingUserForMessageSending(
                    // post: widget.model,
                    sendToUserCallback: (user) {
                  selectUserForChatController.sendMessage(
                      toUser: user, post: widget.model);
                }));
      }),
      const Spacer(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ThemeIconWidget(
            ThemeIcon.clock,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(widget.model.postTime.tr,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
        ],
      )
    ]);
  }

  Widget addPostUserInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 35,
            width: 35,
            child: UserAvatarView(
              size: 35,
              user: widget.model.user,
              onTapHandler: () {
                openProfile();
              },
            )),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.model.user.userName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w500),
                ).ripple(() {
                  openProfile();
                }),
                if (widget.model.club != null)
                  Expanded(
                    child: Text(
                      ' (${widget.model.club!.name})',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).primaryColor),
                      maxLines: 1,
                    ).ripple(() {
                      openClubDetail();
                    }),
                  ),
              ],
            ),
            widget.model.user.city != null
                ? Text(
                    '${widget.model.user.city!}, ${widget.model.user.country!}',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : Container()
          ],
        )),
        SizedBox(
          height: 20,
          width: 20,
          child: ThemeIconWidget(
            ThemeIcon.more,
            color: Theme.of(context).iconTheme.color,
            size: 15,
          ),
        ).borderWithRadius(context: context, value: 1, radius: 15).ripple(() {
          openActionPopup();
        })
      ],
    );
  }

  Widget videoPostTile(PostGallery media) {
    return VisibilityDetector(
      key: Key(media.id.toString()),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        // if (visiblePercentage > 80) {
        homeController.setCurrentVisibleVideo(
            media: media, visibility: visiblePercentage);
        // }
      },
      child: Obx(() => VideoPostTile(
            url: media.filePath,
            isLocalFile: false,
            play: homeController.currentVisibleVideoId.value == media.id,
          )),
    );
  }

  Widget photoPostTile(PostGallery media) {
    return CachedNetworkImage(
      imageUrl: media.filePath,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      placeholder: (context, url) => AppUtil.addProgressIndicator(context, 100),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  void openActionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => widget.model.user.isMe
            ? Wrap(
                children: [
                  ListTile(
                      title: Center(
                          child: Text(
                        LocalizationString.deletePost,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w900),
                      )),
                      onTap: () async {
                        Get.back();
                        postCardController.deletePost(
                            post: widget.model,
                            context: context,
                            callback: () {
                              widget.removePostHandler();
                            });
                      }),
                  divider(context: context),
                  ListTile(
                      title: Center(child: Text(LocalizationString.cancel)),
                      onTap: () => Get.back()),
                ],
              )
            : Wrap(
                children: [
                  ListTile(
                      title: Center(
                          child: Text(LocalizationString.report,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w900))),
                      onTap: () async {
                        Get.back();
                        postCardController.reportPost(
                            post: widget.model,
                            context: context,
                            callback: () {
                              widget.removePostHandler();
                            });
                      }),
                  divider(context: context),
                  ListTile(
                      title: Center(
                          child: Text(LocalizationString.blockUser,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w900))),
                      onTap: () async {
                        Get.back();
                        postCardController.blockUser(
                            userId: widget.model.user.id,
                            context: context,
                            callback: () {
                              widget.removePostHandler();
                            });
                      }),
                  divider(context: context),
                  ListTile(
                      title: Center(
                        child: Text(LocalizationString.cancel,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                )),
                      ),
                      onTap: () => Get.back()),
                ],
              ));
  }

  void openComments() {
    Get.bottomSheet(CommentsScreen(
      isPopup: true,
      model: widget.model,
    ));
    // Get.to(() => CommentsScreen(
    //       model: widget.model,
    //     ));
  }

  void openProfile() async {
    if (widget.model.user.isMe) {
      Get.to(() => const MyProfile(
            showBack: true,
          ));
    } else {
      Get.to(() => OtherUserProfile(userId: widget.model.user.id));
    }
  }

  void openClubDetail() async {
    Get.to(() => ClubDetail(
        club: widget.model.club!,
        needRefreshCallback: () {},
        deleteCallback: (club) {}));
  }
}
