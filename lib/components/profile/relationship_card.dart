import 'package:flutter/material.dart';
import 'package:foap/helper/common_import.dart';
import 'package:foap/helper/extension.dart';
import 'package:foap/manager/service_locator.dart';
import 'package:get/get.dart';
import '../../controllers/relationship_controller.dart';
import '../../helper/localization_strings.dart';
import '../../model/myRelations/my_relations_model.dart';
import '../avatar_view.dart';

class RelationshipCard extends StatelessWidget {
  final MyRelationsModel relationship;

  const RelationshipCard({Key? key, required this.relationship})
      : super(key: key);

  String getRelationFromId(int id) {
    final RelationshipController relationshipController = Get.find();

    List outputList = relationshipController.relationshipNames
        .where((o) => o.id == id)
        .toList();
    return outputList.isNotEmpty ? outputList[0].name : '';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarView(
            url: relationship.user?.picture ?? '',
            size: 70,
            name: relationship.user?.userName,
          ),
          Text(
            relationship.user?.userName ?? '',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w300),
          ).setPadding(top: 15, bottom: 2),
          Text(
            getRelationFromId(relationship.relationShipId ?? 0),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          if (relationship.status != 4)
            Text(
              LocalizationString.requestPending,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
        ],
      ).vP16,
    );
  }
}
