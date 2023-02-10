import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseStoryForHighlights extends StatefulWidget {
  const ChooseStoryForHighlights({Key? key}) : super(key: key);

  @override
  State<ChooseStoryForHighlights> createState() =>
      _ChooseStoryForHighlightsState();
}

class _ChooseStoryForHighlightsState extends State<ChooseStoryForHighlights> {
  final HighlightsController _highlightsController = Get.find();

  final _numberOfColumns = 3;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _highlightsController.getAllStories();
    });
  }

  @override
  void dispose() {
    _highlightsController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).primaryColor,
                size: 27,
              ).ripple(() {
                Get.back();
              }),
              const Spacer(),
              // Image.asset(
              //   'assets/logo.png',
              //   width: 80,
              //   height: 25,
              // ),
              const Spacer(),
              ThemeIconWidget(
                ThemeIcon.nextArrow,
                color: Theme.of(context).primaryColor,
                size: 27,
              ).ripple(() {
                // create highlights
                Get.to(() => const CreateHighlight());
              }),
            ],
          ).hp(20),
          const SizedBox(height: 20),
          Expanded(
            child: GetBuilder<HighlightsController>(
                init: _highlightsController,
                builder: (ctx) {
                  return _highlightsController.isLoading
                      ? const StoriesShimmerWidget()
                      : _highlightsController.stories.isNotEmpty
                          ? GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: 0.6,
                                      crossAxisCount: _numberOfColumns),
                              itemCount: _highlightsController.stories.length,
                              itemBuilder: (context, index) {
                                return _buildItem(index);
                              }).hP16
                          : emptyData(
                              title: LocalizationString.noStoryFound,
                              subTitle:
                              LocalizationString.postSomeStories,
                              context: context);
                }).hP4,
          )
        ],
      ),
    );
  }

  _isSelected(int id) {
    return _highlightsController.selectedStoriesMedia
        .where((item) => item.id == id)
        .isNotEmpty;
  }

  _selectItem(int index) async {
    var highlight = _highlightsController.stories[index];

    setState(() {
      if (_isSelected(highlight.id)) {
        _highlightsController.selectedStoriesMedia
            .removeWhere((anItem) => anItem.id == highlight.id);
        if (_highlightsController.selectedStoriesMedia.isEmpty) {
          _highlightsController.selectedStoriesMedia
              .add(_highlightsController.stories[0]);
          setState(() {});
        }
      } else {
        if (_highlightsController.selectedStoriesMedia.length < 10) {
          _highlightsController.selectedStoriesMedia.add(highlight);
        }
      }
    });
  }

  _buildItem(int index) => GestureDetector(
      onTap: () {
        _selectItem(index);
      },
      child: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                CachedNetworkImage(
  imageUrl:
                  _highlightsController.stories[index].image!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ).round(5),
                _highlightsController.stories[index].isVideoPost() == true
                    ? const Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: ThemeIconWidget(
                          ThemeIcon.play,
                          size: 80,
                          color: Colors.white,
                        ))
                    : Container()
              ],
            ),
          ),
          _isSelected(_highlightsController.stories[index].id)
              ? Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    height: 20,
                    width: 20,
                    color: Theme.of(context).primaryColor,
                    child: const ThemeIconWidget(ThemeIcon.checkMark),
                  ).circular)
              : Container()
        ],
      ));
}
