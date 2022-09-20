import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EnlargeImageViewScreen extends StatefulWidget {
  final PostModel? model;
  final File file;
  final VoidCallback? handler;

  const EnlargeImageViewScreen(
      {Key? key, this.model, required this.file, this.handler})
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
    file = widget.file;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ThemeIconWidget(
                  ThemeIcon.backArrow,
                  size: 20,
                  color: Colors.white,
                ).ripple(() {
                  Get.back();
                }),
                model == null
                    ? Container()
                    : InkWell(
                        onTap: () {
                          Get.to(
                              () => OtherUserProfile(userId: model!.user.id));
                        },
                        child: Text(
                          model!.user.userName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white),
                        )),
                model == null
                    ? Container()
                    : Text(
                            model!.isReported
                                ? LocalizationString.reported
                                : LocalizationString.report,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w600)
                                .copyWith(color: Colors.white))
                        .ripple(() {
                        openReportPostPopup();
                      }),
              ],
            ).hP16,
            divider(context: context).vP8,
            Expanded(
              child: Stack(children: [
                PhotoView(imageProvider: Image.file(file).image),
                model == null
                    ? Container()
                    : Positioned(
                        bottom: 15,
                        left: 15,
                        right: 15,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () => likeUnlikeApiCall(),
                                        child: Icon(
                                            model!.isLike
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.white,
                                            size: 25)),
                                    Text(
                                        model!.totalLike > 1
                                            ? '${model!.totalLike} ${LocalizationString.likes}'
                                            : '${model!.totalLike} ${LocalizationString.like}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(color: Colors.white)
                                            .copyWith(
                                                fontWeight: FontWeight.w900))
                                  ]),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () => openComments(),
                                        child: const Icon(
                                            Icons.comment_outlined,
                                            color: Colors.white)),
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
                                                          FontWeight.w900)
                                                  .copyWith(
                                                      color: Colors.white))
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
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 25),
                      child: Text(LocalizationString.wantToReport,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w300))),
                  ListTile(
                      leading: const Icon(Icons.camera_alt_outlined,
                          color: Colors.black87),
                      title: Text(LocalizationString.report,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w300)),
                      onTap: () async {
                        Navigator.of(context).pop();
                        reportPostApiCall();
                      }),
                  divider(context: context),
                  ListTile(
                      leading: const Icon(Icons.close, color: Colors.black87),
                      title: Text(LocalizationString.cancel,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w300)),
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
