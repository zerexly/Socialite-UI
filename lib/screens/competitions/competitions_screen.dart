import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({Key? key}) : super(key: key);

  @override
  CompetitionsState createState() => CompetitionsState();
}

class CompetitionsState extends State<CompetitionsScreen> {
  List<String> competitionsArr = [
    LocalizationString.current,
    LocalizationString.completed,
    LocalizationString.winners,
  ];

  final CompetitionController competitionController = Get.find();

  @override
  void initState() {
    competitionController.getCompetitions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: competitionsArr.length,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
            context: context,
            title: LocalizationString.competition,
          ),
          divider(context: context).vP8,
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 2,
            unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w900),
            tabs: List.generate(competitionsArr.length, (int index) {
              return Visibility(
                visible: true,
                child: Tab(
                  text: competitionsArr[index],
                ),
              );
            }),
          ),
          divider(context: context),
          GetBuilder<CompetitionController>(
              init: competitionController,
              builder: (ctx) {
                return Expanded(
                    child: TabBarView(
                  children: List.generate(competitionsArr.length, (int index) {
                    return index == 0
                        ? addCompetitionsList(competitionController.current)
                        : index == 1
                            ? addCompetitionsList(
                                competitionController.completed)
                            : addCompetitionsList(
                                competitionController.winners);
                  }),
                ));
              })
        ]),
      ),
    );
  }

  addCompetitionsList(List<CompetitionModel> arr) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: arr.length,
      itemBuilder: (context, index) {
        CompetitionModel model = arr[index];
        return CompetitionCard(
            model: model,
            handler: () {
              model.isPast
                  ? Get.to(
                      () => CompletedCompetitionDetail(competitionId: model.id))
                  : Get.to(() => CompetitionDetailScreen(
                      competitionId: model.id,
                      refreshPreviousScreen: () {
                        competitionController.getCompetitions();
                      }));
            });
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}
