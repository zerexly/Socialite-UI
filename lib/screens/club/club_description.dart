import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ClubDescription extends StatefulWidget {
  const ClubDescription({Key? key}) : super(key: key);

  @override
  ClubDescriptionState createState() => ClubDescriptionState();
}

class ClubDescriptionState extends State<ClubDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // appBar: CustomNavigationBar(
      //   child: appBar(),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
            context: context,
            title: LocalizationString.clubDescription,
          ),
          divider(context: context).tP8,
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a Description',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Describe your group so people know what is about',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 10,
              ),
              const InputField(
                hintText: 'Describe your group',
                maxLines: 5,
                showBorder: true,
                cornerRadius: 5,
              )
            ],
          ).hP16,
          const Spacer(),
          FilledButtonType1(
              text: LocalizationString.done,
              onPress: () {
                // Get.to(() => const InviteUsersToClub());
                // NavigationService.instance.navigateToRoute(
                //     MaterialPageRoute(builder: (ctx) => InviteUser()));
              }).hP16,
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
