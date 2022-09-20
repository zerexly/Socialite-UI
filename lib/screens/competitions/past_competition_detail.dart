import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PastCompetitionDetail extends StatefulWidget {
  final CompetitionModel competition;

  const PastCompetitionDetail({Key? key, required this.competition})
      : super(key: key);

  @override
  PastCompetitionDetailState createState() => PastCompetitionDetailState();
}

class PastCompetitionDetailState extends State<PastCompetitionDetail> {
  late final CompetitionModel model;

  @override
  void initState() {
    super.initState();
    model = widget.competition;
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
          Stack(children: [
            SingleChildScrollView(
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(
                children: [
                  Container(
                      height: 270.0,
                      margin: const EdgeInsets.only(bottom: 30),
                      child: CachedNetworkImage(
                        imageUrl: model.photo,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        placeholder: (context, url) =>
                            AppUtil.addProgressIndicator(context),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                  applyShader(),
                  CompetitionHighlightBar(model: model)
                ],
              ),
              model.winnerAnnounced()
                  ? Column(
                      children: [
                        for (CompetitionPositionModel position
                            in model.competitionPositions)
                          winnerInfo(forPosition: position),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.description,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor)),
                        addPhotoGrid(),
                      ],
                    ).setPadding(top: 16, bottom: 16, left: 16, right: 16),
            ])),
            // addBottomActionButton()
          ]),
        ],
      ),
    );
  }

  Widget winnerInfo({required CompetitionPositionModel forPosition}) {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        // Displaying LoadingSpinner to indicate waiting state
        if (snapshot.hasData) {
          UserModel winner = snapshot.data as UserModel;
          return model.mainWinnerId() == winner.id
              ? winnerDetailCard(forPosition: forPosition, winner: winner)
                  .shadow(context:context )
                  .p16
              : winnerDetailCard(forPosition: forPosition, winner: winner).p16;
        } else {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              child: Center(
                child: Text('Loading...',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor))
                    .vP25,
              )).shadow(context:context ).p16;
        }
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: getOtherUserDetailApi(forPosition.winnerUserId.toString()),
    );
  }

  Widget winnerDetailCard(
      {required CompetitionPositionModel forPosition,
      required UserModel winner}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                forPosition.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
              ).hP4,
              Image.asset(
                'assets/trophy.png',
                height: 20,
              )
            ],
          ).bP8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Handle:',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
              ).hP4,
              Text(winner.userName,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600))
                  .ripple(() {
                Get.to(() => OtherUserProfile(userId: winner.id));
              }),
            ],
          ).bP8,
          winner.country != null && winner.city != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Location',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
                    ).hP4,
                    Text('${winner.country}, ${winner.city!}',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
                  ],
                ).bP8
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Prize: ',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
              ).hP4,
              Text(
                  model.awardType == 2
                      ? '${model.awardedValueForUser(winner.id)} ${LocalizationString.coins}'
                      : '\$${model.awardedValueForUser(winner.id)} ${LocalizationString.inRewards}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor)),
            ],
          )
        ],
      ).vP25,
    );
  }

  addPhotoGrid() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      model.posts.isNotEmpty
          ? Text(LocalizationString.submittedPhotos,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600).copyWith(color: Theme.of(context).primaryColor))
              .vP16
          : Container(),
      model.posts.isNotEmpty
          ? MasonryGridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              itemCount: model.posts.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () async {
                    File path = await AppUtil.findPath(
                        model.posts[index].gallery.first.filePath);
                    Get.to(() => EnlargeImageViewScreen(
                          model: model.posts[index],
                          file: path,
                          handler: () {},
                        ));
                  },
                  child: ClipRRect(
                      child: model.posts[index].gallery.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl:
                                  model.posts[index].gallery.first.filePath,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  AppUtil.addProgressIndicator(context),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
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

  addBottomActionButton() {
    return Positioned(
      bottom: 0,
      child: InkWell(
          onTap: () {
            if (model.winnerId != '') {
              Get.to(
                  () => WinnerDetailScreen(winnerPost: model.winnerPost.first));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                  model.winnerId == ''
                      ? LocalizationString.winnerAnnouncementPending
                      : LocalizationString.viewWinner,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600)),
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
