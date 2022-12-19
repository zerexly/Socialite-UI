import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CompletedCompetitionDetail extends StatefulWidget {
  final int competitionId;

  const CompletedCompetitionDetail({Key? key, required this.competitionId})
      : super(key: key);

  @override
  CompletedCompetitionDetailState createState() =>
      CompletedCompetitionDetailState();
}

class CompletedCompetitionDetailState
    extends State<CompletedCompetitionDetail> {
  final CompetitionController competitionController = Get.find();
  SettingsController settingsController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (widget.competition != null) {
      //   competitionController.setCompetition(widget.competition!);
      // } else {
      competitionController.loadCompetitionDetail(id: widget.competitionId);
      // }
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
          backNavigationBarWithIcon(
              context: context,
              icon: ThemeIcon.privacyPolicy,
              title: LocalizationString.competition,
              iconBtnClicked: () {
                Get.to(() => WebViewScreen(
                    header: LocalizationString.disclaimer,
                    url: settingsController.setting.value!.disclaimerUrl!));
              }),
          // divider(context: context).tP16,
          Expanded(
            child: Stack(children: [
              Obx(() {
                CompetitionModel? competition =
                    competitionController.competition.value;
                return competition == null
                    ? Container()
                    : SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Stack(
                              children: [
                                Container(
                                    height: 270.0,
                                    margin: const EdgeInsets.only(bottom: 30),
                                    child: CachedNetworkImage(
                                      imageUrl: competition.photo,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      placeholder: (context, url) =>
                                          AppUtil.addProgressIndicator(
                                              context, 100),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )),
                                applyShader(),
                                CompetitionHighlightBar(model: competition)
                              ],
                            ),
                            competition.winnerAnnounced()
                                ? Column(
                                    children: [
                                      for (CompetitionPositionModel position
                                          in competition.competitionPositions)
                                        winnerInfo(
                                            forPosition: position,
                                            competition: competition),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(competition.description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      addPhotoGrid(competition: competition),
                                    ],
                                  ).setPadding(
                                    top: 16, bottom: 16, left: 16, right: 16),
                          ]));
              }),
              // addBottomActionButton()
            ]),
          ),
        ],
      ),
    );
  }

  Widget winnerInfo(
      {required CompetitionPositionModel forPosition,
      required CompetitionModel competition}) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Displaying LoadingSpinner to indicate waiting state
        if (snapshot.hasData) {
          UserModel winner = snapshot.data as UserModel;
          return competition.mainWinnerId() == winner.id
              ? winnerDetailCard(
                      position: forPosition,
                      winner: winner,
                      competition: competition)
                  .shadow(context: context)
                  .p16
              : winnerDetailCard(
                      position: forPosition,
                      winner: winner,
                      competition: competition)
                  .p16;
        } else {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: Center(
                child: Text('Loading...',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Theme.of(context).primaryColor))
                    .vP25,
              )).shadow(context: context).p16;
        }
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: getOtherUserDetailApi(forPosition.winnerUserId.toString()),
    );
  }

  Widget winnerDetailCard(
      {required CompetitionPositionModel position,
      required UserModel winner,
      required CompetitionModel competition}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    position.title,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ).hP4,
                  Image.asset(
                    'assets/trophy.png',
                    height: 30,
                  )
                ],
              ).bP8,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${LocalizationString.user} :',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ).hP4,
                  Text(winner.userName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900))
                      .ripple(() {
                    Get.to(() => OtherUserProfile(userId: winner.id));
                  }),
                ],
              ).bP8,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${LocalizationString.prize}: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ).hP4,
                  Text(
                      competition.awardType == 2
                          ? '${competition.awardedValueForUser(winner.id)} ${LocalizationString.coins}'
                          : '\$${competition.awardedValueForUser(winner.id)} ${LocalizationString.inRewards}',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              )
            ],
          ),
          const Spacer(),
          SizedBox(
              width: 100,
              height: 120,
              child: CachedNetworkImage(
                imageUrl: position.post!.gallery.first.filePath,
                fit: BoxFit.cover,
              ).round(20))
        ],
      ).p(10),
    ).ripple(() {
      Get.to(() => SinglePostDetail(postId: position.post!.id));
    });
  }

  Widget addPhotoGrid({required CompetitionModel competition}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      competition.posts.isNotEmpty
          ? Text(LocalizationString.submittedPhotos,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w800)
                      .copyWith(color: Theme.of(context).primaryColor))
              .tP16
          : Container(),
      competition.posts.isNotEmpty
          ? MasonryGridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              itemCount: competition.posts.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () async {
                    // File path = await AppUtil.findPath(
                    //     model.posts[index].gallery.first.filePath);
                    Get.to(() => EnlargeImageViewScreen(
                          model: competition.posts[index],
                          // file: path,
                          handler: () {},
                        ));
                  },
                  child: ClipRRect(
                      child: competition.posts[index].gallery.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: competition
                                  .posts[index].gallery.first.filePath,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  AppUtil.addProgressIndicator(context, 100),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ).round(10)
                          : Container())),
              // staggeredTileBuilder: (int index) => new StaggeredTile.count(1, 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )
          : Container(),
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

  addBottomActionButton({required CompetitionModel competition}) {
    return Positioned(
      bottom: 0,
      child: InkWell(
          onTap: () {
            if (competition.winnerId != '') {
              Get.to(() =>
                  WinnerDetailScreen(winnerPost: competition.winnerPost.first));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                  competition.winnerId == ''
                      ? LocalizationString.winnerAnnouncementPending
                      : LocalizationString.viewWinner,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600)),
            ),
          )),
    );
  }

  Future<UserModel?> getOtherUserDetailApi(String userId) async {
    UserModel? data;
    await ApiController().getOtherUser(userId).then((response) async {
      if (response.success) {
        data = response.user;
      } else {}
    });

    return data;
  }
}
