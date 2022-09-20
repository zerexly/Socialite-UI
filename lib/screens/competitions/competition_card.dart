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
        child: Column(children: [
          Stack(
            children: [
              Container(
                  height: 230.0,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: CachedNetworkImage(
                    imageUrl: model.photo,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) =>
                        AppUtil.addProgressIndicator(context),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
              CompetitionHighlightBar(model: model)
            ],
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Text(model.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 20,
                  textAlign: TextAlign.left).vP16),
        ]));
  }

  applyShader() {
    return Container(
        height: 210.0,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
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
      bottom: 0,
      left: 30,
      right: 30,
      child: Container(
        height: 50.0,
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
            mainAxisAlignment: model.winnerAnnounced()
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
            children: [
              model.winnerAnnounced()
                  ? Text('${model.title} Winner : ',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w900,color: Theme.of(context).primaryColor))
                  : Text(
                      model.awardType == 2
                          ? '${LocalizationString.prize} : ${model.totalAwardValue()} ${LocalizationString.coins}'
                          : '${LocalizationString.prize} : \$${model.totalAwardValue()} ${LocalizationString.inRewards}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600)),
              model.winnerAnnounced()
                  ? FutureBuilder(
                      builder: (ctx, snapshot) {
                        // Displaying LoadingSpinner to indicate waiting state
                        if (snapshot.hasData) {
                          return Text(snapshot.data as String,
                              style: Theme
    .of(context)
    .textTheme
    .titleMedium!
    .copyWith(color: Theme
    .of(context)
    .primaryColor, fontWeight: FontWeight.w900));
                        } else {
                          return Text(LocalizationString.loading,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor));
                        }
                      },

                      future: getOtherUserDetailApi(
                          model.mainWinnerId().toString()),
                    )
                  : Text(
                      model.isPast
                          ? LocalizationString.completed
                          : model.timeLeft,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor)
                          .copyWith(fontWeight: FontWeight.w900))
            ]),
      ).shadowWithBorder(context: context,
          borderColor: Theme.of(context).primaryColor, radius: 5, borderWidth: 2),
    );
  }

  Future<String> getOtherUserDetailApi(String userId) async {
    String data = '';
    await ApiController().getOtherUser(userId).then((response) async {
      if (response.success) {
        data = response.user?.userName ??
            response.user?.userName ??
            LocalizationString.noData;
      } else {
        data = LocalizationString.noData;
      }
    });

    return data;
  }
}
