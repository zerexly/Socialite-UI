import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectMusic extends StatefulWidget {
  const SelectMusic({Key? key}) : super(key: key);

  @override
  State<SelectMusic> createState() => _SelectMusicState();
}

class _SelectMusicState extends State<SelectMusic> {
  final CreateReelController _createReelController = Get.find();

  @override
  void initState() {
    super.initState();
    // exploreController.getSuggestedUsers();
  }

  @override
  void didUpdateWidget(covariant SelectMusic oldWidget) {
    // exploreController.getSuggestedUsers();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // exploreController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: KeyboardDismissOnTap(
            child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const ThemeIconWidget(
                  ThemeIcon.backArrow,
                  size: 25,
                ).ripple(() {
                  Get.back();
                }),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: SearchBar(
                      showSearchIcon: true,
                      iconColor: Theme.of(context).primaryColor,
                      onSearchChanged: (value) {
                        _createReelController.searchTextChanged(value);
                      },
                      onSearchStarted: () {
                        //controller.startSearch();
                      },
                      onSearchCompleted: (searchTerm) {}),
                ),
                Obx(() => _createReelController.searchText.isNotEmpty
                    ? Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            color: Theme.of(context).primaryColor,
                            child: ThemeIconWidget(
                              ThemeIcon.close,
                              color: Theme.of(context).backgroundColor,
                              size: 25,
                            ),
                          ).round(20).ripple(() {
                            _createReelController.closeSearch();
                          }),
                        ],
                      )
                    : Container())
              ],
            ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
            GetBuilder<CreateReelController>(
                init: _createReelController,
                builder: (ctx) {
                  return _createReelController.searchText.isNotEmpty
                      ? Expanded(
                          child: Column(
                            children: [
                              segmentView(),
                              divider(context: context, height: 0.2),
                              // searchedResult(segment: exploreController.selectedSegment),
                            ],
                          ),
                        )
                      : searchSuggestionView();
                })
          ],
        )),
      ),
    );
  }

  Widget segmentView() {
    return HorizontalSegmentBar(
        width: MediaQuery.of(context).size.width,
        onSegmentChange: (segment) {
          _createReelController.segmentChanged(segment);
        },
        segments: [
          LocalizationString.top,
          LocalizationString.account,
          LocalizationString.hashTags,
          // LocalizationString.locations,
        ]);
  }

  Widget searchSuggestionView() {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (!_createReelController.isSearching) {
          _createReelController.searchSuggestedMusic();
        }
      }
    });

    return _createReelController.isSearching
        ? Expanded(child: const ShimmerUsers().hP16)
        : _createReelController.musicList.isNotEmpty
            ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      LocalizationString.suggestedForYou,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 20, bottom: 50),
                          itemCount: _createReelController.musicList.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return Container();
                          },
                          separatorBuilder: (BuildContext ctx, int index) {
                            return const SizedBox(
                              height: 20,
                            );
                          }),
                    ),
                  ],
                ).hP16,
              )
            : Container();
  }
}
