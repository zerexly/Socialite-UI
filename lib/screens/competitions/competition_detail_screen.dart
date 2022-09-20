import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CompetitionDetailScreen extends StatefulWidget {
  final CompetitionModel? competition;
  final int? competitionId;

  final VoidCallback refreshPreviousScreen;

  const CompetitionDetailScreen(
      {Key? key,
      this.competition,
      this.competitionId,
      required this.refreshPreviousScreen})
      : super(key: key);

  @override
  CompetitionDetailState createState() => CompetitionDetailState();
}

class CompetitionDetailState extends State<CompetitionDetailScreen> {
  final CompetitionController competitionController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.competition != null) {
        competitionController.setCompetition(widget.competition!);
      } else {
        competitionController.loadCompetitionDetail(id: widget.competitionId!);
      }
    });
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
              ).ripple(() {
                Get.back();
              }),
              Text(
                LocalizationString.competition,
                style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                LocalizationString.disclaimer,
                style: Theme.of(context).textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ).ripple(() {
                Get.to(() => WebViewScreen(
                    header: LocalizationString.disclaimer,
                    url: AppConfigConstants.disclaimerUrl));
              }),
            ],
          ).hP16,
          divider(context: context).vP8,
          const SizedBox(
            height: 20,
          ),
          GetBuilder<CompetitionController>(
              init: competitionController,
              builder: (ctx) {
                return competitionController.competition.value != null
                    ? Expanded(
                        child: Stack(children: [
                          SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: competitionController
                                          .competition.value!.photo,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      placeholder: (context, url) =>
                                          AppUtil.addProgressIndicator(context),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    applyShader(),
                                    CompetitionHighlightBar(
                                        model: competitionController
                                            .competition.value!)
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                            competitionController
                                                .competition.value!.title,
                                            style: Theme.of(context).textTheme
                                                .titleMedium!
                                                .copyWith(fontWeight: FontWeight.w900,color: Theme.of(context).primaryColor))
                                        .bP8,
                                    Text(
                                        competitionController
                                            .competition.value!.description,
                                        style: Theme.of(context).textTheme.titleMedium),
                                  ],
                                ).p16,
                                competitionController.competition.value!
                                            .competitionMediaType ==
                                        1
                                    ? addPhotoGrid()
                                    : addVideoGrid(),
                              ])),
                          addBottomActionButton()
                        ]),
                      )
                    : Container();
              }),
        ],
      ),
    );
  }

  addVideoGrid() {
    CompetitionModel model = competitionController.competition.value!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      model.exampleImages.isNotEmpty
          ? Text(
              LocalizationString.exampleVideos,
              style: Theme.of(context).textTheme.displaySmall!
                  .copyWith(fontWeight: FontWeight.w900),
            ).hP16
          : Container(),
      MasonryGridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        itemCount: model.exampleImages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => InkWell(
            onTap: () async {
              //Get.to(() => VideoPlayerScreen(url: model!.exampleImages[index]));
            },
            child: VTImageView(
              assetPlaceHolder: 'assest/placeholder.png',
              videoUrl: model.exampleImages[index],
              width: 200.0,
              height: 200.0,
              errorBuilder: (context, error, stack) {
                return Container(
                  width: 200.0,
                  height: 200.0,
                  color: Colors.green,
                  child: const Center(
                    child: Text("error loading Image"),
                  ),
                );
              },
            )),
        // staggeredTileBuilder: (int index) => new StaggeredTile.count(1, 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      const SizedBox(height: 65)
    ]).hP16;
  }

  addPhotoGrid() {
    CompetitionModel model = competitionController.competition.value!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      model.exampleImages.isNotEmpty
          ? Text(LocalizationString.examplePhotos,
                  style: Theme.of(context).textTheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w900))
              .hP16
          : Container(),
      MasonryGridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: 2,
        itemCount: model.exampleImages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => InkWell(
            onTap: () async {
              File path = await AppUtil.findPath(model.exampleImages[index]);

              Get.to(() => EnlargeImageViewScreen(file: path, handler: () {}));
            },
            child: CachedNetworkImage(
              imageUrl: model.exampleImages[index],
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  AppUtil.addProgressIndicator(context),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ).round(10)),
        // staggeredTileBuilder: (int index) => new StaggeredTile.count(1, 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      const SizedBox(height: 65)
    ]);
  }

  applyShader() {
    return Container(
        height: 270.0,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
              stops: const [
                0.0,
                1.0
              ]),
        ));
  }

  addBottomActionButton() {
    CompetitionModel model = competitionController.competition.value!;

    String title;
    var loggedInUserPost = model.posts
        .where((element) =>
            element.user.id == getIt<UserProfileManager>().user!.id)
        .toList();
    if (model.isJoined == 1) {
      title = loggedInUserPost.isNotEmpty
          ? LocalizationString.viewSubmission
          : model.competitionMediaType == 1
              ? LocalizationString.postPhoto
              : LocalizationString.postVideo;
    } else {
      title =
          "${LocalizationString.joined} (${LocalizationString.fee} ${model.joiningFee} ${LocalizationString.coins})";
    }

    return Positioned(
      bottom: 0,
      child: InkWell(
          onTap: () async {
            if (model.isJoined == 1) {
              //Already Joined Mission
              if (loggedInUserPost.isNotEmpty) {
                //User have already published post for this competition
                competitionController.viewMySubmission(model);
              } else {
                competitionController.submitMedia(model);
              }
            } else {
              competitionController.joinCompetition(model,context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 95,
            color: Theme.of(context).primaryColor,
            child: Center(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor)
                      .copyWith(fontWeight: FontWeight.w900)),
            ),
          )),
    );
  }
}
