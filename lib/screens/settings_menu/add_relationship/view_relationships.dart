import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import '../../../controllers/relationship_controller.dart';

class ViewRelationship extends StatefulWidget {
  final int userId;

  const ViewRelationship({Key? key, required this.userId}) : super(key: key);

  @override
  State<ViewRelationship> createState() => _ViewRelationshipState();
}

class _ViewRelationshipState extends State<ViewRelationship> {
  final RelationshipController _relationshipController = Get.find();

  var isSwitched = false;

  @override
  void initState() {
    super.initState();
    _relationshipController.getUsersRelationships(userId: widget.userId);
    _relationshipController.getMyRelationships();
  }

  String getRelationFromId(int id) {
    List outputList = _relationshipController.relationshipNames
        .where((o) => o.id == id)
        .toList();
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
          backNavigationBar(
              context: context, title: LocalizationString.relationship),
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
                          _relationshipController.relationships.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index !=
                            _relationshipController.relationships.length) {
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
                                            .relationships[index]
                                            .user
                                            ?.picture ??
                                        '',
                                    size: 110,
                                  ).tP25,
                                  Text(
                                    _relationshipController.relationships[index]
                                            .user?.userName ??
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
                                            .relationships[index]
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
                                          .relationships[index].status !=
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
                          return Container();
                        }
                      }).paddingAll(10);
                }),
          )
        ],
      ),
    );
  }
}
