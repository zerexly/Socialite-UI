import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

enum QuickLinkType { live, randomChat, randomCall, competition, clubs, pages, tv }

class QuickLink {
  String icon;
  String heading;
  String subHeading;
  QuickLinkType linkType;

  QuickLink(
      {required this.icon,
      required this.heading,
      required this.subHeading,
      required this.linkType});
}

class QuickLinkWidget extends StatefulWidget {
  const QuickLinkWidget({Key? key}) : super(key: key);

  @override
  State<QuickLinkWidget> createState() => _QuickLinkWidgetState();
}

class _QuickLinkWidgetState extends State<QuickLinkWidget> {
  List<QuickLink> quickLinks = [
    // QuickLink(
    //     icon: 'assets/live_broadcasting.png',
    //     heading: LocalizationString.live,
    //     subHeading: LocalizationString.joinLiveProfessionals,
    //     linkType: QuickLinkType.live),
    QuickLink(
        icon: 'assets/competitions.png',
        heading: LocalizationString.competition,
        subHeading: LocalizationString.joinCompetitionsToEarn,
        linkType: QuickLinkType.competition),
    QuickLink(
        icon: 'assets/club_colored.png',
        heading: LocalizationString.clubs,
        subHeading: LocalizationString.placeForPeopleOfCommonInterest,
        linkType: QuickLinkType.clubs),
    // QuickLink(
    //     icon: 'assets/page_colored.png',
    //     heading: LocalizationString.page,
    //     subHeading: LocalizationString.spaceForBusiness,
    //     linkType: QuickLinkType.pages),
    // QuickLink(
    //     icon: 'assets/random_call_colored.png',
    //     heading: LocalizationString.randomCall,
    //     subHeading: LocalizationString.haveFunByRandomCalling,
    //     linkType: QuickLinkType.randomCall),
    QuickLink(
        icon: 'assets/chat_colored.png',
        heading: LocalizationString.strangerChat,
        subHeading: LocalizationString.haveFunByRandomChatting,
        linkType: QuickLinkType.randomChat),
    // QuickLink(
    //     icon: 'assets/television.png',
    //     heading: LocalizationString.tvs,
    //     subHeading: LocalizationString.watchTvs,
    //     linkType: QuickLinkType.tv),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16),
        scrollDirection: Axis.horizontal,
        itemCount: quickLinks.length,
        itemBuilder: (context, index) {
          QuickLink link = quickLinks[index];
          return quickLinkView(link).ripple(() {
            if (link.linkType == QuickLinkType.live) {
              Get.to(() => const RandomLiveListing());
            } else if (link.linkType == QuickLinkType.competition) {
              Get.to(() => const CompetitionsScreen());
            } else if (link.linkType == QuickLinkType.randomChat) {
              if (AppConfigConstants.isDemoApp) {
                AppUtil.showDemoAppConfirmationAlert(
                    title: 'Demo app',
                    subTitle:
                        'This is demo app so might not find online user to test it',
                    cxt: context,
                    okHandler: () {
                      Get.to(() => const FindRandomUser(
                            isCalling: false,
                          ));
                    });
                return;
              } else {
                Get.to(() => const FindRandomUser(
                      isCalling: false,
                    ));
              }
            } else if (link.linkType == QuickLinkType.randomCall) {
              Get.to(() => const FindRandomUser(
                    isCalling: true,
                  ));
            } else if (link.linkType == QuickLinkType.clubs) {
              Get.to(() => const ClubsListing());
            } else if (link.linkType == QuickLinkType.pages) {}
            else if (link.linkType == QuickLinkType.tv
            ) {
              Get.to(() => const TvListDashboard());
            }
          });
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }

  Widget quickLinkView(QuickLink link) {
    return Container(
      height: 50,
      // width: 200,
      color: Theme.of(context).cardColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            link.icon,
            height: 28,
            width: 28,
          ),
          // const Spacer(),
          const SizedBox(
            width: 10,
          ),
          Text(
            link.heading.tr,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor),
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Text(
          //   link.subHeading,
          //   style: Theme.of(context).textTheme.bodyMedium,
          // ),
          // const SizedBox(
          //   height: 5,
          // ),
        ],
      ).hP16,
    ).round(20);
  }

// Widget quickLinkView(QuickLink link) {
//   return Container(
//     height: 170,
//     width: 170,
//     color: Theme.of(context).cardColor,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset(
//           link.icon,
//           height: 60,
//           width: 60,
//         ),
//         const Spacer(),
//         Text(
//           link.heading,
//           style: Theme.of(context).textTheme.titleSmall!.copyWith(
//               fontWeight: FontWeight.w900,
//               color: Theme.of(context).primaryColor),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Text(
//           link.subHeading,
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//       ],
//     ).p8,
//   ).round(10);
// }
}
