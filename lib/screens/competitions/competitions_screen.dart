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
          titleNavigationBar(
            context: context,
            title: LocalizationString.competition,
          ),
          divider(context: context).vP8,
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 2,
            unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
            labelStyle: Theme.of(context)
                .textTheme
                .titleMedium!
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
                return FutureBuilder(
                  future: competitionController.getCompetitions(), // async work
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      ApiResponseModel apiResponse = snapshot.data;
                      if (apiResponse.success) {
                        var allCompetitions = apiResponse.competitions;
                        competitionController.current = allCompetitions
                            .where((element) => element.isOngoing)
                            .toList();
                        competitionController.completed = allCompetitions
                            .where((element) => element.isPast)
                            .toList();
                        competitionController.winners = allCompetitions
                            .where((element) => element.winnerAnnounced())
                            .toList();

                        return Expanded(
                            child: TabBarView(
                          children: List.generate(competitionsArr.length,
                              (int index) {
                            return index == 0
                                ? addCompetitionsList(
                                    competitionController.current)
                                : index == 1
                                    ? addCompetitionsList(
                                        competitionController.completed)
                                    : addCompetitionsList(
                                        competitionController.winners);
                          }),
                        ));
                      } else {
                        return Center(
                            child: Text(
                          LocalizationString.noData,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ));
                      }
                    } else {
                      //Show Loader
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      );
                    }
                  },
                );
              })
        ]),
      ),
    );
  }

  addCompetitionsList(List<CompetitionModel> arr) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: arr.length,
      itemBuilder: (context, index) {
        CompetitionModel model = arr[index];
        return CompetitionCard(
            model: model,
            handler: () {
              model.isPast
                  ? Get.to(() => PastCompetitionDetail(competition: model))
                  : Get.to(() => CompetitionDetailScreen(
                      competition: model,
                      refreshPreviousScreen: () {
                        competitionController.getCompetitions();
                      }));
            });
      },
    );
  }
}
