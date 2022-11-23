import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class UsersList extends StatefulWidget {
  final List<UserModel> usersList;

  const UsersList({Key? key, required this.usersList}) : super(key: key);

  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  late List<UserModel> usersList = [];

  @override
  void initState() {
    usersList = widget.usersList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
                onTap: () => Get.back(),
                child:
                    Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color)),
            Center(
                child: Text(
                  LocalizationString.friendsNearBy,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),
            )),
            Container()
          ])),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 25),
        itemCount: usersList.length,
        itemBuilder: (context, index) {
          return SelectableUserTile(model: usersList[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            height: 0.1,
            width: double.infinity,
            color: Theme.of(context).dividerColor,
          ).vP4;
        },
      ).hP16,
    );
  }
}
