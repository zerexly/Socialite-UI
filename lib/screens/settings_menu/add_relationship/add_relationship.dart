import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/settings_menu/add_relationship/search_relation_profile.dart';
import 'package:get/get.dart';
import '../../../controllers/relationship_controller.dart';

class AddRelationship extends StatefulWidget {
  const AddRelationship({Key? key}) : super(key: key);

  @override
  State<AddRelationship> createState() => _AddRelationshipState();
}

class _AddRelationshipState extends State<AddRelationship> {
  final RelationshipController _relationshipController = Get.find();
  @override
  void initState() {
    super.initState();
    _relationshipController.getRelationships();
    _relationshipController.getMyRelationships();
    _relationshipController.getMyInvitations(() {
      setState(() {});
    });
  }

  String getRelationFromId(int id) {
    List outputList =
        _relationshipController.relationship.where((o) => o.id == id).toList();
    return outputList.isNotEmpty ? outputList[0].name : '';
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
          backNavigationBarWithIconBadge(
              context: context,
              icon: ThemeIcon.notification,
              title: LocalizationString.myFamily,
              badgeCount: _relationshipController.myInvitations.isNotEmpty
                  ? _relationshipController.myInvitations.length
                  : 0,
              iconBtnClicked: () {}),
          divider(context: context).tP8,
          Expanded(
            child: GetBuilder<RelationshipController>(
                init: _relationshipController,
                builder: (ctx) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 5,
                              mainAxisExtent: 260),
                      padding: EdgeInsets.zero,
                      itemCount:
                          _relationshipController.myRelationships.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index !=
                            _relationshipController.myRelationships.length) {
                          return Card(
                            color: Theme.of(context).cardColor,
                            margin: const EdgeInsets.all(6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Container(
                              height: 260,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AvatarView(
                                    url: _relationshipController
                                            .myRelationships[index]
                                            .user
                                            ?.picture ??
                                        '',
                                    size: 110,
                                  ).tP25,
                                  Text(
                                    _relationshipController
                                            .myRelationships[index]
                                            .user
                                            ?.username ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white),
                                  ).paddingOnly(top: 15, bottom: 2),
                                  Text(
                                    getRelationFromId(_relationshipController
                                            .myRelationships[index]
                                            .relationShipId ??
                                        0),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                  ),
                                  if (_relationshipController
                                          .myRelationships[index].status !=
                                      4)
                                    Text(
                                      LocalizationString.pendingApproval,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context).primaryColor),
                                    ).paddingOnly(top: 10),
                                ],
                              ),
                            ),
                          ).ripple(() {});
                        } else {
                          return Card(
                                  color: Colors.grey,
                                  margin: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: const Center(child: Text('Add')))
                              .ripple(() {
                            openBottomSheet();
                          });
                        }
                      }).paddingAll(10);
                }),
          )
        ],
      ),
    );
  }

  openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
              itemCount: _relationshipController.relationship.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.account_box),
                  title: Text(
                      _relationshipController.relationship[index].name ?? ''),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => SearchProfile(
                        relationId:
                            _relationshipController.relationship[index].id,
                        actionPerformed: () {
                          _relationshipController.getMyRelationships();
                        }));
                  },
                );
              });
        });
  }
}
