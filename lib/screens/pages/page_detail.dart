import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class PageDetail extends StatefulWidget {
  final ClubModel club;

  const PageDetail({Key? key, required this.club}) : super(key: key);

  @override
  PageDetailState createState() => PageDetailState();
}

class PageDetailState extends State<PageDetail> {
  late ClubModel group;
  List<PostModel> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    group = widget.club;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 350,
                      child: CachedNetworkImage(
                        imageUrl: group.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Text(group.name,
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .titleMedium!
                    //             .copyWith(fontWeight: FontWeight.w600))
                    //     .p16,
                    Row(
                      children: [
                        const ThemeIconWidget(ThemeIcon.userGroup),
                        Text(
                          'Public group',
                          style: Theme.of(context).textTheme.titleMedium,
                        ).hP8,
                        Text(
                          '250K members',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        )
                      ],
                    ).hP16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 30,
                            width:
                                (MediaQuery.of(context).size.width - 32) * 0.48,
                            child: FilledButtonType1(
                                text: LocalizationString.join, onPress: () {})),
                        SizedBox(
                            height: 30,
                            width:
                                (MediaQuery.of(context).size.width - 32) * 0.48,
                            child: FilledButtonType1(
                                enabledBackgroundColor:
                                    Theme.of(context).disabledColor,
                                text: LocalizationString.invite,
                                onPress: () {}))
                      ],
                    ).p16,
                  ],
                ).shadowWithoutRadius(context: context),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: (posts.length * 500) + (posts.length * 40),
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, index) {
                        return PostCard(
                          model: posts[index],
                          textTapHandler: (text) {},
                          // likeTapHandler: () {},
                          removePostHandler: () {},
                          // mediaTapHandler: (post){
                          //   Get.to(()=> PostMediaFullScreen(post: post));
                          // },
                        );
                      },
                      separatorBuilder: (BuildContext context, index) {
                        return const SizedBox(
                          height: 40,
                        );
                      },
                      itemCount: posts.length),
                ).vP16.shadowWithoutRadius(context: context)
              ]))
            ],
          ),
          Positioned(
            child: Container(
              height: 120.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.black.withOpacity(0.5),
                        Colors.grey.withOpacity(0.0),
                      ],
                      stops: const [
                        0.0,
                        0.5,
                        1.0
                      ])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ThemeIconWidget(
                    ThemeIcon.backArrow,
                    size: 20,
                    color: Colors.white,
                  ).ripple(() {
                    Get.back();
                  }),
                  Text(
                    LocalizationString.clubs,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ).hP16,
            ),
          ),
        ],
      ),
    );
  }

  showActionSheet(PostModel post) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet1(
              items: [
                GenericItem(
                    id: '1',
                    title: LocalizationString.share,
                    icon: ThemeIcon.share),
                GenericItem(
                    id: '2',
                    title: LocalizationString.report,
                    icon: ThemeIcon.report),
                GenericItem(
                    id: '3',
                    title: LocalizationString.hide,
                    icon: ThemeIcon.hide),
              ],
              itemCallBack: (item) {},
            ));
  }
}
