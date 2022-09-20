import 'package:foap/helper/common_import.dart';

class DashboardScreen extends StatefulWidget {
  final int? selectedTab;

  const DashboardScreen({Key? key, this.selectedTab}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen> {

  int _currentIndex = 0;
  List<Widget> items = [];
  final picker = ImagePicker();
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedTab ?? 0;

    items = [
      const HomeFeedScreen(),
      const Explore(),
      const SelectMedia(),
      const CompetitionsScreen(),
      const MyProfile()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: items[_currentIndex],
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).viewPadding.bottom > 0 ? 90 : 70.0,
          width: MediaQuery.of(context).size.width,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).backgroundColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: Colors.grey,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                      _currentIndex == 0
                          ? 'assets/home_selected.png'
                          : 'assets/home.png',
                      height: 20,
                      width: 20,
                      color: _currentIndex == 0
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor),
                  label: ''),
              BottomNavigationBarItem(
                icon: Image.asset(
                    _currentIndex == 1
                        ? 'assets/search_selected.png'
                        : 'assets/search.png',
                    height: 20,
                    width: 20,
                    color: _currentIndex == 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: const SizedBox(
                  height: 30,
                  width: 30,
                  child: ThemeIconWidget(
                    ThemeIcon.plus,
                    size: 30,
                    color: Colors.white,
                  ),
                ).shadow(context: context,fillColor: Theme.of(context).primaryColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                    _currentIndex == 3
                        ? 'assets/competition_selected.png'
                        : 'assets/competition.png',
                    height: 20,
                    width: 20,
                    color: _currentIndex == 3
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                    _currentIndex == 4
                        ? 'assets/account_selected.png'
                        : 'assets/account.png',
                    height: 20,
                    width: 20,
                    color: _currentIndex == 4
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor),
                label: '',
              ),
            ],
          ).shadow(context: context),
        ));
  }

  void onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }
}
