import 'package:foap/helper/common_import.dart';

class CompetitionCard extends StatefulWidget {
  final CompetitionModel model;
  final VoidCallback handler;

  const CompetitionCard({Key? key, required this.model, required this.handler})
      : super(key: key);

  @override
  CompetitionCardState createState() => CompetitionCardState();
}

class CompetitionCardState extends State<CompetitionCard> {
  late final CompetitionModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => widget.handler(),
        child: SizedBox(
          height: 200,
          child: Column(children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: model.photo,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  placeholder: (context, url) =>
                      AppUtil.addProgressIndicator(context,100),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ).round(20),
                CompetitionHighlightBar(model: model)
              ],
            ),
          ]),
        )).hP16;
  }
}

class CompetitionHighlightBar extends StatefulWidget {
  final CompetitionModel model;

  const CompetitionHighlightBar({Key? key, required this.model})
      : super(key: key);

  @override
  State<CompetitionHighlightBar> createState() =>
      _CompetitionHighlightBarState();
}

class _CompetitionHighlightBarState extends State<CompetitionHighlightBar> {
  late CompetitionModel model;

  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 30,
      right: 30,
      child: Container(
        height: 50.0,
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
            mainAxisAlignment: model.winnerAnnounced()
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              model.winnerAnnounced()
                  ? Text('Winner : ',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor))
                  : Text(
                      model.awardType == 2
                          ? '${LocalizationString.prize} : ${model.totalAwardValue()} ${LocalizationString.coins}'
                          : '${LocalizationString.prize} : \$${model.totalAwardValue()}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800)),
              model.winnerAnnounced()
                  ? FutureBuilder(
                      builder: (ctx, snapshot) {
                        // Displaying LoadingSpinner to indicate waiting state
                        if (snapshot.hasData) {
                          UserModel? user = snapshot.data as UserModel?;

                          return user == null
                              ? Text(LocalizationString.loading)
                              : Text(
                                  user.isMe
                                      ? LocalizationString.you
                                      : user.userName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w900));
                        } else {
                          return Text(LocalizationString.loading,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor));
                        }
                      },
                      future: getOtherUserDetailApi(
                          model.mainWinnerId().toString()),
                    )
                  : Text(
                      model.isPast
                          ? LocalizationString.completed
                          : model.timeLeft,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).primaryColor)
                          .copyWith(fontWeight: FontWeight.w700))
            ]),
      ).shadowWithBorder(
          shadowOpacity: 0.1,
          context: context,
          borderColor: Theme.of(context).primaryColor,
          radius: 15,
          borderWidth: 2),
    );
  }

  Future<UserModel?> getOtherUserDetailApi(String userId) async {
    UserModel? user;
    await ApiController().getOtherUser(userId).then((response) async {
      if (response.success) {
        user = response.user!;
      }
    });

    return user;
  }
}
