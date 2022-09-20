import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  final PostModel model;
  final Function(String) textTapHandler;
  final VoidCallback likeTapHandler;

  const PostCard(
      {Key? key,
      required this.model,
      required this.textTapHandler,
      required this.likeTapHandler})
      : super(key: key);

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  final HomeController homeController = Get.find();
  final PostCardController postCardController = Get.find();
  final ChatDetailController chatDetailController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      addPostUserInfo().hP16,
      mediaTile(),
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
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w600),
            basicStyle: Theme.of(context).textTheme.bodyLarge,
            onTap: (tappedText) {
              widget.textTapHandler(tappedText);
              // postCardController.titleTextTapped(text: tappedText,post: widget.model);
            },
          ),
        ],
      ).hP16
    ]).vP16.shadow(context: context, radius: 10).hP16;
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
                  postCardController.updateGallerySlider(index);
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
                    () => DotsIndicator(
                      dotsCount: widget.model.gallery.length,
                      position:
                          postCardController.currentIndex.value.toDouble(),
                      decorator: DotsDecorator(
                          activeColor: Theme.of(context).primaryColor),
                    ),
                  ),
                ))
          ],
        ).vP16,
      );
    } else {
      return widget.model.gallery.first.isVideoPost() == true
          ? videoPostTile(widget.model.gallery.first).vP16
          : SizedBox(
              height: 350,
              child: photoPostTile(widget.model.gallery.first).vP16);
    }
  }

  List<Widget> mediaList() {
    return widget.model.gallery.map((item) {
      if (item.isVideoPost() == true) {
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
              width: 15,
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
        width: 25,
      ),
      InkWell(
          onTap: () {
            widget.likeTapHandler();
          },
          child: ThemeIconWidget(
            widget.model.isLike ? ThemeIcon.favFilled : ThemeIcon.fav,
            color: widget.model.isLike
                ? Theme.of(context).errorColor
                : Theme.of(context).iconTheme.color,
          )),
      const SizedBox(
        width: 15,
      ),
      widget.model.totalLike > 0
          ? Text('${widget.model.totalLike}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w900))
          : Container(),
      const SizedBox(
        width: 25,
      ),
      ThemeIconWidget(
        ThemeIcon.share,
        color: Theme.of(context).iconTheme.color,
      ).ripple(() {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => SelectUserToSendMessage(
                post: widget.model,
                sendToUserCallback: (user) {
                  // chatDetailController.sendPostAsMessage(
                  //     post: widget.model, toOpponent: user);
                },
                selectedUser: (user) {
                  // chatDetailController.sendPostAsMessage(
                  //     post: widget.model, toOpponent: user);
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
          Text(widget.model.postTime,
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
        InkWell(
            onTap: () => openProfile(),
            child: SizedBox(
                height: 40,
                width: 40,
                child: UserAvatarView(
                  user: widget.model.user,
                  onTapHandler: () {
                    // open live
                  },
                ))),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                onTap: () => openProfile(),
                child: Text(
                  widget.model.user.userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w700),
                )),
            Text(
              '${widget.model.user.city!}, ${widget.model.user.country!}',
              style: Theme.of(context).textTheme.bodyLarge,
            )
            // Text(
            //   'Location to add',
            //   style: Theme.of(context).textTheme.bodyLarge,
            // )
          ],
        )),
        widget.model.isMyPost
            ? Container()
            : SizedBox(
                height: 20,
                width: 20,
                child: ThemeIconWidget(
                  ThemeIcon.more,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ),
              )
                .borderWithRadius(context: context, value: 2, radius: 15)
                .ripple(() {
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
        homeController.setCurrentVisibleVideo(
            media: media, visibility: visiblePercentage);
      },
      child: VideoPostTile(
        url: media.filePath,
        isLocalFile: false,
        play: homeController.currentVisibleVideoId.value == media.id,
      ),
    );
  }

  Widget photoPostTile(PostGallery media) {
    return CachedNetworkImage(
      imageUrl: media.filePath,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      placeholder: (context, url) => AppUtil.addProgressIndicator(context),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  void openActionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(child: Text(LocalizationString.report)),
                    onTap: () async {
                      Get.back();
                      postCardController.reportPost(widget.model, context);
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.blockUser)),
                    onTap: () async {
                      Get.back();
                      postCardController.blockUser(
                          widget.model.user.id, context);
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.cancel)),
                    onTap: () => Get.back()),
              ],
            ));
  }

  void openComments() {
    Get.to(() => CommentsScreen(
          model: widget.model,
        ));
  }

  void openProfile() async {
    Get.to(OtherUserProfile(userId: widget.model.user.id));
  }
}
