import 'package:foap/helper/common_import.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  GenericItem? selectedItem;

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
            context: context,
            title: LocalizationString.createClub,
          ),
          divider(context: context).tP8,
          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const InputField(
                  showBorder: true,
                  cornerRadius: 5,
                  hintText: 'Name  your group',
                ),
                divider(context: context).vP16,
                Stack(
                  children: const [
                    AbsorbPointer(
                      child: InputField(
                        showBorder: true,
                        cornerRadius: 5,
                        hintText: 'Choose privacy',
                        // onPress: () {
                        //   print('onPress');
                        // },
                      ),
                    ),
                    SizedBox(height: 40,width: double.infinity,)
                  ],
                ).ripple((){
                  showActionSheet();
                }),
                const Spacer(),
                divider(context: context).vP16,
                FilledButtonType1(
                    text: LocalizationString.createGroup,
                    onPress: () {
                      //Get.to(() => const ChooseClubCoverPhoto());
                      // NavigationService.instance.navigateToRoute(
                      //     MaterialPageRoute(builder: (ctx) => ChooseCoverPhoto()));
                    }).bP25
              ],
            ).hP16,
          )
        ],
      ),
    );
  }

  showActionSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet(
              items: [
                GenericItem(
                    id: '1',
                    title: LocalizationString.public,
                    subTitle:
                        'Anyone can see who\'s in the group and what they post',
                    isSelected: selectedItem?.id == '1',
                    icon: ThemeIcon.public),
                GenericItem(
                    id: '2',
                    title: LocalizationString.private,
                    subTitle:
                        'Only members can see who\'s in the group and what they post',
                    isSelected: selectedItem?.id == '2',
                    icon: ThemeIcon.lock),
              ],
              itemCallBack: (item) {
                setState(() {
                  selectedItem = item;
                });
              },
            ));
  }
}
