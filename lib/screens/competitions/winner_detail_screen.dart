import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class WinnerDetailScreen extends StatefulWidget {
  final PostModel winnerPost;

  const WinnerDetailScreen({Key? key, required this.winnerPost})
      : super(key: key);

  @override
  WinnerDetailState createState() => WinnerDetailState();
}

class WinnerDetailState extends State<WinnerDetailScreen> {
  late final PostModel model;

  @override
  void initState() {
    super.initState();
    model = widget.winnerPost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            LocalizationString.winner,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
          ),
          leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios_rounded,
                  color: Colors.black)),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            addUserInfo(),
            Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Text(model.title, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).backgroundColor))),
            Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 5, bottom: 15),
                child: Text(model.tags.join(' '),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).backgroundColor,fontWeight: FontWeight.w600))),
            InkWell(
                onTap: () async {
                  // File path =
                  //     await AppUtil.findPath(model.gallery.first.filePath);

                  Get.to(() => EnlargeImageViewScreen(
                          model: model,
                          handler: () {
                            setState(() {});
                          }));
                },
                child: SizedBox(
                    height: 300.0,
                    child: CachedNetworkImage(
                      imageUrl: model.gallery.first.filePath,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                      placeholder: (context, url) =>
                          AppUtil.addProgressIndicator(context,100),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ))),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () => likeUnlikeApiCall(),
                              child: Icon(
                                  model.isLike ? Icons.star : Icons.star_border,
                                  color: Theme.of(context).primaryColor,
                                  size: 25)),
                          model.totalLike > 0
                              ? Text(
                                  '${model.totalLike} ${LocalizationString.likes}',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).backgroundColor))
                              : Container(),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () => openComments(),
                              child: Icon(Icons.comment_outlined,
                                  color: Theme.of(context).primaryColor)),
                          InkWell(
                            onTap: () => openComments(),
                            child: model.totalComment > 0
                                ? Text(
                                    '${model.totalComment} ${LocalizationString.comments}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).backgroundColor))
                                : Container(),
                          )
                        ])
                  ]),
            ),
          ]),
        ));
  }

  addUserInfo() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () => openProfile(),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: Theme.of(context).primaryColor)),
              child: model.user.picture != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: CachedNetworkImage(
                        imageUrl: model.user.picture!,
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            AppUtil.addProgressIndicator(context,100),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ))
                  : Icon(Icons.person, color: Colors.grey.shade600, size: 40),
            ),
            const SizedBox(width: 5),
            Text(model.user.userName, style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor)),
          ]),
        ));
  }

  void likeUnlikeApiCall() {
    setState(() {
      model.isLike = !model.isLike;
      model.totalLike =
          model.isLike ? model.totalLike + 1 : model.totalLike - 1;
    });
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController()
            .likeUnlike(!model.isLike, model.id)
            .then((response) async {});
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: false);
      }
    });
  }

  void openComments() {
    Get.to(() => CommentsScreen(
            model: model,
            handler: () {
              setState(() {});
            }));
  }

  void openProfile() async {
    var _ = await Get.to(() => OtherUserProfile(userId: model.user.id));

    setState(() {});
  }
}
