import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventsDashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt unreadMsgCount = 0.obs;
  RxBool isLoading = false.obs;

  indexChanged(int index) {
    currentIndex.value = index;
  }

  updateUnreadMessageCount(int count) {
    unreadMsgCount.value = count;
  }
}

class EventsDashboardScreen extends StatefulWidget {
  const EventsDashboardScreen({Key? key}) : super(key: key);

  @override
  EventsDashboardScreenState createState() => EventsDashboardScreenState();
}

class EventsDashboardScreenState extends State<EventsDashboardScreen> {
  final EventsDashboardController _dashboardController =
      EventsDashboardController();

  List<Widget> items = [];
  bool hasPermission = false;

  @override
  void initState() {
    items = [
      const EventsListing(),
      const SearchEventListing(),
      const EventBookingScreen()
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
                  icon: Image.asset('assets/event.png',
                      height: 20,
                      width: 20,
                      color: _dashboardController.currentIndex.value == 0
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Image.asset('assets/search.png',
                      height: 20,
                      width: 20,
                      color: _dashboardController.currentIndex.value == 1
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                  label: ''),
              BottomNavigationBarItem(
                icon: Image.asset('assets/bookings.png',
                    height: 20,
                    width: 20,
                    color: _dashboardController.currentIndex.value == 2
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
