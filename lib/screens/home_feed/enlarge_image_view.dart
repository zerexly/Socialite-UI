import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EnlargeImageViewScreen extends StatefulWidget {
  final PostModel model;
  final VoidCallback? handler;

  const EnlargeImageViewScreen({Key? key, required this.model, this.handler})
      : super(key: key);

  @override
  EnlargeImageViewState createState() => EnlargeImageViewState();
}

class EnlargeImageViewState extends State<EnlargeImageViewScreen> {
  late PostModel? model;
  late File file;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ThemeIconWidget(
                      ThemeIcon.backArrow,
                      size: 20,
                    ).ripple(() {
                      Get.back();
                    }),
                    const Spacer(),
                    model == null
                        ? Container()
                        : Text(
                                model!.isReported
                                    ? LocalizationString.reported
                                    : LocalizationString.report,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w600))
                            .ripple(() {
                            openReportPostPopup();
                          }),
                  ],
                ),
                model == null
                    ? Container()
                    : Positioned(
                        left: 0,
                        right: 0,
                        child: Center(
                          child: InkWell(
                              onTap: () {
                                Get.to(() =>
                                    OtherUserProfile(userId: model!.user.id));
                              },
                              child: Text(
                                model!.user.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              )),
                        ),
                      ),
              ],
            ).hP16,
            divider(context: context).vP8,
            Expanded(
              child: Stack(children: [
                CachedNetworkImage(
                    imageUrl: widget.model.gallery.first.filePath).addPinchAndZoom(),
                model == null
                    ? Container()
                    : Positioned(
                        bottom: 40,
                        left: 15,
                        right: 15,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () => likeUnlikeApiCall(),
                                        child: ThemeIconWidget(
                                            model!.isLike
                                                ? ThemeIcon.filledStar
                                                : ThemeIcon.star,
                                            size: 25)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        model!.totalLike > 1
                                            ? '${model!.totalLike} ${LocalizationString.likes}'
                                            : '${model!.totalLike} ${LocalizationString.like}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500))
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () => openComments(),
                                        child: const ThemeIconWidget(
                                            ThemeIcon.message)),
                                    InkWell(
                                      onTap: () => openComments(),
                                      child: model!.totalComment > 0
                                          ? Text(
                                              '${model!.totalComment} ${LocalizationString.comments}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w900))
                                          : Container(),
                                    )
                                  ])
                            ]),
                      )
              ]),
            ),
          ],
        ));
  }

  void openReportPostPopup() {
    if (!model!.isReported) {
      showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(
                children: [
                  Text(LocalizationString.wantToReport,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w700))
                      .p16,
                  ListTile(
                      leading: const ThemeIconWidget(ThemeIcon.camera),
                      title: Text(LocalizationString.report,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w300)),
                      onTap: () async {
                        Navigator.of(context).pop();
                        reportPostApiCall();
                      }),
                  divider(context: context),
                  ListTile(
                      leading: const ThemeIconWidget(ThemeIcon.close),
                      title: Text(LocalizationString.cancel,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w300)),
                      onTap: () => Navigator.of(context).pop()),
                ],
              ));
    }
  }

  void openComments() {
    Get.to(() => CommentsScreen(
        model: model!,
        handler: () {
          if (widget.handler != null) {
            widget.handler!();
          }

          setState(() {});
        }));
  }

  void likeUnlikeApiCall() {
    model!.isLike = !model!.isLike;
    model!.totalLike =
        model!.isLike ? (model!.totalLike) + 1 : (model!.totalLike) - 1;

    if (widget.handler != null) {
      widget.handler!();
    }

    setState(() {});

    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController()
            .likeUnlike(!model!.isLike, model!.id)
            .then((response) async {});
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

  void reportPostApiCall() {
    model!.isReported = true;
    if (widget.handler != null) {
      widget.handler!();
    }

    setState(() {});
    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().reportPost(model!.id).then((response) async {
          EasyLoading.dismiss();
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }
}
