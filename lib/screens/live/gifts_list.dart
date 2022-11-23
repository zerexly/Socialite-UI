import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class GiftsPageView extends StatefulWidget {
  final Function(GiftModel) giftSelectedCompletion;

  const GiftsPageView({Key? key, required this.giftSelectedCompletion})
      : super(key: key);

  @override
  State<GiftsPageView> createState() => _GiftsPageViewState();
}

class _GiftsPageViewState extends State<GiftsPageView> {
  int currentView = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = [
      GiftsListing(giftSelectedCompletion: widget.giftSelectedCompletion),
      coinPackages(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.darken(0.48),
      child: Column(
        children: [
          Container(
            height: 60,
            color: Theme.of(context).primaryColor.darken(0.48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${LocalizationString.availableCoins} : ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    ThemeIconWidget(
                      ThemeIcon.diamond,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      getIt<UserProfileManager>().user!.coins.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                currentView == 0
                    ? Container(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              LocalizationString.coins,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ).setPadding(left: 10, right: 10, top: 5, bottom: 5))
                        .round(20)
                        .ripple(() {
                        setState(() {
                          currentView = 1;
                        });
                      })
                    : const ThemeIconWidget(
                        ThemeIcon.close,
                        size: 20,
                      ).ripple(() {
                        setState(() {
                          currentView = 0;
                        });
                      }),
              ],
            ).p16,
          ).topRounded(20),
          Expanded(child: pages[currentView]),
        ],
      ),
    );
  }

  Widget coinPackages() {
    return const CoinPackagesWidget();
  }
}

class GiftsListing extends StatefulWidget {
  final Function(GiftModel) giftSelectedCompletion;

  const GiftsListing({Key? key, required this.giftSelectedCompletion})
      : super(key: key);

  @override
  State<GiftsListing> createState() => _GiftsListingState();
}

class _GiftsListingState extends State<GiftsListing> {
  final GiftController _giftController = Get.find();

  @override
  void initState() {
    _giftController.loadGiftCategories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor.darken(),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Obx(() => HorizontalSegmentBar(
                onSegmentChange: (segment) {
                  _giftController.segmentChanged(segment);
                },
                adjustInMinimumWidth: true,
                hideHighlightIndicator: false,
                segments: _giftController.giftsCategories
                    .map((element) => element.name)
                    .toList(),
              )),
          Expanded(
            child: GetBuilder<GiftController>(
                init: _giftController,
                builder: (ctx) {
                  return GridView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 25),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 0.6,
                              crossAxisCount: 4),
                      itemCount: _giftController.gifts.length,
                      itemBuilder: (context, index) {
                        GiftModel gift = _giftController.gifts[index];
                        return giftBox(gift).ripple(() {
                          widget.giftSelectedCompletion(gift);
                        });
                      });
                }),
          ),
        ],
      ),
    );
  }

  Widget giftBox(GiftModel gift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          gift.logo,
          height: 60,
          width: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThemeIconWidget(
              ThemeIcon.diamond,
              size: 15,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(gift.coins.toString()),
          ],
        )
      ],
    ).round(10);
  }
}
