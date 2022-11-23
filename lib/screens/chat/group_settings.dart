import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class GroupSettings extends StatefulWidget {
  const GroupSettings({Key? key}) : super(key: key);

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  final ChatRoomDetailController _chatRoomDetailController = Get.find();

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
              context: context, title: LocalizationString.groupSettings),
          divider(context: context).tP8,
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Theme.of(context).cardColor,
            height: 65,
            child: Column(
              // padding: const EdgeInsets.only(top: 10, bottom: 10),
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      color: Theme.of(context).primaryColor,
                      child: const ThemeIconWidget(
                        ThemeIcon.send,
                        size: 20,
                      ),
                    ).round(5),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      LocalizationString.sendMessages,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Obx(() => Text(
                          _chatRoomDetailController.room.value!.groupAccess == 1
                              ? LocalizationString.onlyAdmins
                              : LocalizationString.allParticipants,
                          style: Theme.of(context).textTheme.titleSmall,
                        )),
                    const ThemeIconWidget(
                      ThemeIcon.nextArrow,
                      size: 12,
                    )
                  ],
                ).ripple(() {
                  openActionSheetForSendMessage();
                }),
              ],
            ).p16,
          ),
        ],
      ),
    );
  }

  openActionSheetForSendMessage() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet1(
              items: [
                GenericItem(
                  id: '1',
                  title: LocalizationString.allParticipants,
                  subTitle: LocalizationString.allParticipants,
                  // isSelected: selectedItem?.id == '1',
                ),
                GenericItem(
                  id: '2',
                  title: LocalizationString.onlyAdmins,
                  subTitle: LocalizationString.onlyAdmins,
                  // isSelected: selectedItem?.id == '1',
                ),
              ],
              itemCallBack: (item) {
                if (item.id == '1') {
                  _chatRoomDetailController.updateGroupAccess(2);
                } else if (item.id == '2') {
                  _chatRoomDetailController.updateGroupAccess(1);
                }
              },
            ));
  }

}
