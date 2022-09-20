import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class AddPostScreen extends StatefulWidget {
  final List<Media> items;
  final int? competitionId;

  const AddPostScreen({Key? key, required this.items, this.competitionId})
      : super(key: key);

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPostScreen> {
  TextEditingController descriptionText = TextEditingController();

  final AddPostController addPostController = Get.find();
  final ExploreController exploreController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<AddPostController>(
          init: addPostController,
          builder: (ctx) {
            return Stack(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 55,
                      ),
                      Row(
                        children: [
                          InkWell(
                              onTap: () => Get.back(),
                              child:
                                  const ThemeIconWidget(ThemeIcon.backArrow)),
                          const Spacer(),
                          Text(
                            LocalizationString.share,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600),
                          ).ripple(() {
                            addPostController.uploadAllPostImages(
                                context: context,
                                items: widget.items,
                                title: descriptionText.text,
                                competitionId: widget.competitionId);
                          })
                        ],
                      ).hP16,
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mediaListView(isLarge: false).ripple(() {
                            addPostController.togglePreviewMode();
                          }),
                          Expanded(child: addDescriptionView()),
                        ],
                      ).hP16,
                      Obx(() {
                        return addPostController.isEditing.value == 1
                            ? Expanded(
                                child: Container(
                                  // height: 500,
                                  width: double.infinity,
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.1),
                                  child: addPostController
                                          .currentHashtag.isNotEmpty
                                      ? hashTagView()
                                      : addPostController
                                              .currentUserTag.isNotEmpty
                                          ? usersView()
                                          : Container(),
                                ),
                              )
                            : Container();
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      // Obx(() => Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           LocalizationString.allowComments,
                      //           style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                      //         ),
                      //         ThemeIconWidget(
                      //           addPostController.allowComments.value
                      //               ? ThemeIcon.selectedCheckbox
                      //               : ThemeIcon.emptyCheckbox,
                      //           size: 20,
                      //           color: addPostController.allowComments.value
                      //               ? Theme.of(context).primaryColor
                      //               : Theme.of(context).iconTheme.color,
                      //         ).ripple(() {
                      //           addPostController.toggleAllowCommentsSetting();
                      //         })
                      //       ],
                      //     ).hP16)
                    ]),
                addPostController.isPreviewMode.value
                    ? Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(0.2),
                            child: mediaListView(isLarge: true),
                          ),
                          Positioned(
                              top: 50,
                              left: 16,
                              child: const ThemeIconWidget(
                                ThemeIcon.close,
                                size: 20,
                              ).ripple(() {
                                addPostController.togglePreviewMode();
                              }))
                        ],
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  Widget mediaListView({required bool isLarge}) {
    return SizedBox(
      width: isLarge ? MediaQuery.of(context).size.width : 80,
      height: isLarge ? MediaQuery.of(context).size.height : 80,
      child: Stack(
        children: [
          CarouselSlider(
            items: [
              for (Media media in widget.items)
                Image.memory(
                  media.thumbnail!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ).round(5)
            ],
            options: CarouselOptions(
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              height: double.infinity,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                addPostController.updateGallerySlider(index);
              },
            ),
          ),
          widget.items.length > 1
              ? Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).backgroundColor,
                          child: const ThemeIconWidget(ThemeIcon.multiplePosts))
                      .circular,
                )
              : Container()
        ],
      ),
    );
  }

  Widget addDescriptionView() {
    return SizedBox(
      height: 100,
      child: Obx(() {
        descriptionText.value = TextEditingValue(
            text: addPostController.searchText.value,
            selection: TextSelection.fromPosition(
                TextPosition(offset: addPostController.position.value)));

        return Focus(
          child: TextField(
            controller: descriptionText,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 5,
            onChanged: (text) {
              addPostController.textChanged(
                  text, descriptionText.selection.baseOffset);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                counterText: "",
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor),
                hintText: LocalizationString.addSomethingAboutPost),
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus == true) {
              addPostController.startedEditing();
            } else {
              addPostController.stoppedEditing();
            }
          },
        );
      }),
    );
  }

  usersView() {
    return GetBuilder<AddPostController>(
        init: addPostController,
        builder: (ctx) {
          return ListView.separated(
              padding: const EdgeInsets.only(top: 20),
              itemCount: addPostController.searchedUsers.length,
              itemBuilder: (BuildContext ctx, int index) {
                return UserTile(
                  profile: addPostController.searchedUsers[index],
                  viewCallback: () {
                    addPostController.addUserTag(
                        addPostController.searchedUsers[index].userName);
                  },
                );
              },
              separatorBuilder: (BuildContext ctx, int index) {
                return const SizedBox(
                  height: 20,
                );
              }).hP16;
        });
  }

  hashTagView() {
    return GetBuilder<AddPostController>(
        init: addPostController,
        builder: (ctx) {
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16),
            itemCount: addPostController.hashTags.length,
            itemBuilder: (BuildContext ctx, int index) {
              return HashTagTile(
                hashtag: addPostController.hashTags[index],
                onItemCallback: () {
                  addPostController
                      .addHashTag(addPostController.hashTags[index].name);
                },
              );
            },
          );
        });
  }
}
