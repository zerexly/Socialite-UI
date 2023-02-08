import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/settings_menu/add_relationship/search_relation_profile.dart';
import 'package:get/get.dart';
import '../../../controllers/relationship_controller.dart';

enum Privacy { Nobody, MyContacts, Everyone }

class AddRelationship extends StatefulWidget {
  const AddRelationship({Key? key}) : super(key: key);

  @override
  State<AddRelationship> createState() => _AddRelationshipState();
}

class _AddRelationshipState extends State<AddRelationship> {
  final RelationshipController _relationshipController = Get.find();
  final ProfileController _profileController = Get.find();

  var isSwitched = false;

  @override
  void initState() {
    super.initState();
    _profileController.getMyProfile();
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
              iconBtnClicked: () {
                Privacy _privacy = _profileController
                            .user.value?.userSetting?[0].relationSetting ==
                        0
                    ? Privacy.Nobody
                    : _profileController
                                .user.value?.userSetting?[0].relationSetting ==
                            1
                        ? Privacy.Everyone
                        : Privacy.MyContacts;
                print(_profileController
                    .user.value?.userSetting?[0].relationSetting);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(content: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width - 20,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: Text(
                                      'Choose who can view your Relationships',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('Nobody'),
                                    leading: Radio<Privacy>(
                                      value: Privacy.Nobody,
                                      groupValue: _privacy,
                                      onChanged: (Privacy? value) {
                                        setState(() {
                                          _privacy = value!;
                                        });
                                        _relationshipController
                                            .postRelationshipSettings(
                                                0,
                                                () => {
                                                      _profileController
                                                          .getMyProfile()
                                                    });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('My Contacts'),
                                    leading: Radio<Privacy>(
                                      value: Privacy.MyContacts,
                                      groupValue: _privacy,
                                      onChanged: (Privacy? value) {
                                        setState(() {
                                          _privacy = value!;
                                        });
                                        _relationshipController
                                            .postRelationshipSettings(
                                                2,
                                                () => {
                                                      _profileController
                                                          .getMyProfile()
                                                    });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: const Text('Everyone'),
                                    leading: Radio<Privacy>(
                                      value: Privacy.Everyone,
                                      groupValue: _privacy,
                                      onChanged: (Privacy? value) {
                                        setState(() {
                                          _privacy = value!;
                                        });
                                        _relationshipController
                                            .postRelationshipSettings(
                                                1,
                                                () => {
                                                      _profileController
                                                          .getMyProfile()
                                                    });
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: BorderButtonType1(
                                            text: LocalizationString.close,
                                            height: 30,
                                            width: 70,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w600)
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                            onPress: () {
                                              Navigator.pop(context);
                                            })
                                        .paddingOnly(
                                            left: 15, right: 10, bottom: 10),
                                  ),
                                ],
                              ),
                            ));
                      }));
                    });
              }),
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
                                              color: Theme.of(context)
                                                  .primaryColor),
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
