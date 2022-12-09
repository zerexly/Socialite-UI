import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChoosePageCoverPhoto extends StatefulWidget {
  const ChoosePageCoverPhoto({Key? key}) : super(key: key);

  @override
  ChoosePageCoverPhotoState createState() => ChoosePageCoverPhotoState();
}

class ChoosePageCoverPhotoState extends State<ChoosePageCoverPhoto> {
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
            title: LocalizationString.addClubCoverPhoto,
          ),
          divider(context: context).tP8,
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Cover Photo',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                'Give people an idea of what your group is about with a photo',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Cover photo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ).hP16,
          SizedBox(
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: 'Assets.dummyProfilePictureUrl',
                  fit: BoxFit.cover,
                ).round(5),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Row(
                        children: [
                          ThemeIconWidget(
                            ThemeIcon.edit,
                            size: 20,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          Text(
                            LocalizationString.edit,
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      ).setPadding(left: 8, right: 8, top: 4, bottom: 4),
                    ).round(5).ripple(() {}))
              ],
            ),
          ).p16,
          SizedBox(
            height: 50,
            child: ListView.separated(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext ctx, int index) {
                  return CachedNetworkImage(
                    imageUrl: 'Assets.dummyProfilePictureUrl',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ).round(5);
                },
                separatorBuilder: (BuildContext ctx, int index) {
                  return const SizedBox(
                    width: 10,
                  );
                }),
          ),
          const Spacer(),
          FilledButtonType1(
              text: LocalizationString.next,
              onPress: () {
                Get.to(() => const ClubDescription());
                // NavigationService.instance.navigateToRoute(
                //     MaterialPageRoute(builder: (ctx) => GroupDescription()));
              }).hP16,
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
