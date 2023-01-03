import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

enum QuickLinkType {
  live,
  randomChat,
  randomCall,
  competition,
  clubs,
  pages,
  tv,
  event,
  story,
  highlights,
  goLive,
  reel,
  podcast
}

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
  final VoidCallback callback;

  const QuickLinkWidget({Key? key, required this.callback}) : super(key: key);

  @override
  State<QuickLinkWidget> createState() => _QuickLinkWidgetState();
}

class _QuickLinkWidgetState extends State<QuickLinkWidget> {
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            clipBehavior: Clip.hardEdge,
            children: [
              for (QuickLink link in _homeController.quickLinks)
                quickLinkView(link).ripple(() {
                  widget.callback();
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
                  } else if (link.linkType == QuickLinkType.pages) {
                  } else if (link.linkType == QuickLinkType.event) {
                    Get.to(() => const EventsDashboardScreen());
                  } else if (link.linkType == QuickLinkType.goLive) {
                    Get.to(() => const CheckingLiveFeasibility());
                  } else if (link.linkType == QuickLinkType.reel) {
                    Get.to(() => const CreateReelScreen());
                  } else if (link.linkType == QuickLinkType.story) {
                    Get.to(() => const ChooseMediaForStory());
                  } else if (link.linkType == QuickLinkType.highlights) {
                    Get.to(() => const ChooseStoryForHighlights());
                  } else if (link.linkType == QuickLinkType.tv) {
                    Get.to(() => const TvListDashboard());
                  } else if (link.linkType == QuickLinkType.podcast) {
                    Get.to(() => const PodcastListDashboard());
                  }
                })
            ]).setPadding(left: 16, right: 16, top: 50));
  }

  Widget quickLinkView(QuickLink link) {
    return Container(
      height: 50,
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
        ],
      ).hP16,
    ).round(40);
  }
}
