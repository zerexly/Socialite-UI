import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'dating_card.dart';
import 'like_list.dart';
import 'matched_list.dart';
import 'set_dating_preference.dart';

class DatingDashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  indexChanged(int index) {
    currentIndex.value = index;
  }
}

class DatingDashboard extends StatefulWidget {
  const DatingDashboard({Key? key}) : super(key: key);

  @override
  State<DatingDashboard> createState() => DatingDashboardState();
}

class DatingDashboardState extends State<DatingDashboard> {
  final DatingDashboardController _dashboardController =
      DatingDashboardController();
  List<Widget> items = [];

  @override
  void initState() {
    items = [
      const DatingCard(),
      const MatchedList(),
      const LikeList(),
      const SetDatingPreference(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: items[_dashboardController.currentIndex.value],
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).viewPadding.bottom > 0 ? 90 : 70.0,
          width: MediaQuery.of(context).size.width,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).backgroundColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: _dashboardController.currentIndex.value,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) => {onTabTapped(index)},
            items: [
              BottomNavigationBarItem(
                  icon: ThemeIconWidget(ThemeIcon.dating,
                      size: 20,
                      color: _dashboardController.currentIndex.value == 0
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                  label: ''),
              BottomNavigationBarItem(
                  icon: ThemeIconWidget(ThemeIcon.favFilled,
                      size: 20,
                      color: _dashboardController.currentIndex.value == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                  label: ''),
              BottomNavigationBarItem(
                  icon: ThemeIconWidget(ThemeIcon.thumbsUp,
                      size: 20,
                      color: _dashboardController.currentIndex.value == 2
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                  label: ''),
              BottomNavigationBarItem(
                icon: ThemeIconWidget(ThemeIcon.filterIcon,
                    size: 20,
                    color: _dashboardController.currentIndex.value == 3
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor),
                label: '',
              ),
            ],
          ).shadow(context: context),
        )));
  }

  void onTabTapped(int index) async {
    Future.delayed(
        Duration.zero, () => _dashboardController.indexChanged(index));
  }
}
