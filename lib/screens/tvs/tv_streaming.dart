import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../../model/tv_show_model.dart';

class LiveTVStreaming extends StatefulWidget {
  final TvModel tvModel;
  final TVShowModel? showModel;

  const LiveTVStreaming({Key? key, required this.tvModel, this.showModel})
      : super(key: key);

  @override
  State<LiveTVStreaming> createState() => _LiveTVStreamingState();
}

class _LiveTVStreamingState extends State<LiveTVStreaming> {
  final TvStreamingController _liveTvStreamingController = Get.find();
  TextEditingController messageTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        AutoOrientation.portraitAutoMode();
      } else {
        AutoOrientation.landscapeAutoMode();
      }

      _liveTvStreamingController.getTvShowEpisodes(
          showId: widget.showModel?.id);
    });
  }

  @override
  void dispose() {
    AutoOrientation.portraitAutoMode();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        AutoOrientation.portraitAutoMode();
      } else {
        AutoOrientation.landscapeAutoMode();
      }
      return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    backNavigationBar(
                      context: context,
                      title: LocalizationString.tvs,
                    ),
                    divider(context: context).tP8,
                    Obx(() {
                      print('updated');
                        return _liveTvStreamingController.selectedEpisode.value != null
                            ? SocialifiedLiveTvVideoPlayer(
                                tvModel: widget.tvModel,
                                videoUrl: _liveTvStreamingController
                                    .selectedEpisode.value!.videoUrl!,
                                play: false,
                                orientation: orientation,
                                showMinimumHeight: isKeyboardVisible,
                              )
                            : Container();}),
                    Obx(() => addEpisodes())
                  ],
                ),
                // Obx(() =>
                //     _liveTvStreamingController.showChatMessages.value == false
                //         ? Positioned(
                //             right: 25,
                //             bottom: 40,
                //             child: Container(
                //               height: 40,
                //               width: 40,
                //               color: Theme.of(context).primaryColor,
                //               child: const ThemeIconWidget(
                //                 ThemeIcon.chat,
                //                 size: 25,
                //               ),
                //             ).circular.ripple(() {
                //               _liveTvStreamingController.showMessagesView();
                //             }),
                //           )
                //         : Container())
              ],
            ));
      });
    });
  }

  Widget bottomView() {
    return Obx(() => _liveTvStreamingController.showChatMessages.value == false
        ? Expanded(child: detailView())
        : Expanded(child: liveChatView()));
  }

  Widget addEpisodes() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: _liveTvStreamingController.tvEpisodes.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? detailView()
              : Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(6),
                    leading: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: _liveTvStreamingController
                                  .tvEpisodes[index - 1].imageUrl ??
                              '',
                          fit: BoxFit.cover,
                          height: 50,
                          width: MediaQuery.of(context).size.width / 4.5,
                        ),
                        const Positioned.fill(child: Icon(Icons.play_circle))
                      ],
                    ),
                    title: Text(
                        _liveTvStreamingController.tvEpisodes[index - 1].name ??
                            ''),
                    dense: true,
                  ).ripple(() {
                    _liveTvStreamingController.playEpisode(
                        _liveTvStreamingController.tvEpisodes[index - 1]);
                  }),
                )
                  .setPadding(left: 16, right: 16, bottom: 5)
                  .round(10)
                  .ripple(() {});
        },
      ),
    );
  }

  Widget detailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                    color: Theme.of(context).primaryColor,
                    child: Text(widget.showModel?.ageGroup ?? "")
                        .setPadding(left: 10, right: 10, top: 5, bottom: 5))
                .round(10),
            const SizedBox(width: 10),
            Container(
                    color: Theme.of(context).primaryColor,
                    child: Text(widget.showModel?.language ?? "")
                        .setPadding(left: 10, right: 10, top: 5, bottom: 5))
                .round(10),
          ],
        ).bP8,
        Row(
          children: [
            CachedNetworkImage(
              imageUrl: widget.showModel?.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  widget.showModel?.name ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                  // maxLines: 3,
                ),
                // Text(
                //   widget.tvModel.description,
                //   style: Theme.of(context).textTheme.bodySmall,
                //   // maxLines: 3,
                // )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.showModel?.description ?? '',
          style: Theme.of(context).textTheme.bodySmall,
          // maxLines: 3,
        ),
      ],
    ).p16;
  }

  Widget liveChatView() {
    return Column(
      children: [Expanded(child: messagesListView()), messageComposerView()],
    );
  }

  Widget messagesListView() {
    return Column(
      children: [
        Container(
          height: 70,
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationString.liveChat,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                      '${widget.tvModel.totalViewer.formatNumber} ${LocalizationString.users}',
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
              const Spacer(),
              const ThemeIconWidget(
                ThemeIcon.close,
                size: 25,
              ).ripple(() {
                _liveTvStreamingController.hideMessagesView();
              }),
            ],
          ).p16,
        ).topRounded(20),
        // const Spacer(),
        Expanded(
          child: GetBuilder<TvStreamingController>(
              init: _liveTvStreamingController,
              builder: (ctx) {
                List<ChatMessageModel> messages = (_liveTvStreamingController
                        .messagesMap[widget.tvModel.id.toString()] ??
                    []);
                return ListView.separated(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 50, left: 16, right: 70),
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        color: Theme.of(context).cardColor.withOpacity(0.5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AvatarView(
                                size: 25,
                                url: messages[index].userPicture,
                                name: messages[index].userName),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messages[index].userName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w900)
                                        .copyWith(color: Colors.white70),
                                  ),
                                  Text(
                                    messages[index].messageContent,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ).p8,
                      ).round(10);
                    },
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    });
              }),
        ),
      ],
    );
  }

  Widget messageComposerView() {
    return Container(
      color: Colors.black,
      height: 70,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  color: Theme.of(context).cardColor.withOpacity(0.8),
                  child: TextField(
                    controller: messageTextField,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                    maxLines: 50,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).primaryColor),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                        hintText: LocalizationString.pleaseEnterMessage),
                  ),
                ).round(10),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                LocalizationString.send,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor)
                    .copyWith(fontWeight: FontWeight.w900),
              ).ripple(() {
                sendMessage(widget.tvModel.id);
              }),
            ],
          ),
        ],
      ).hP16,
    );
  }

  sendMessage(int liveTvId) {
    if (messageTextField.text.removeAllWhitespace.trim().isNotEmpty) {
      _liveTvStreamingController.sendTextMessage(
          messageTextField.text, liveTvId);
      messageTextField.text = '';
      _liveTvStreamingController.showMessagesView();
    }
  }
}
