import 'package:foap/components/thumbnail_view.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class StoryUpdatesBar extends StatelessWidget {
  final List<StoryModel> stories;
  final List<UserModel> liveUsers;

  final VoidCallback addStoryCallback;
  final Function(StoryModel) viewStoryCallback;
  final Function(UserModel) joinLiveUserCallback;

  const StoryUpdatesBar({
    Key? key,
    required this.stories,
    required this.liveUsers,
    required this.addStoryCallback,
    required this.viewStoryCallback,
    required this.joinLiveUserCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16,right: 16),
      scrollDirection: Axis.horizontal,
      itemCount: stories.length + liveUsers.length,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == 0) {
          return SizedBox(
            width: 70,
            child: stories.isNotEmpty
                ? stories[index].media.isEmpty == true
                    ? Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: ThemeIconWidget(
                              ThemeIcon.plus,
                              size: 25,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          )
                              .borderWithRadius(
                                  context: context, value: 2, radius: 20)
                              .ripple(() {
                            addStoryCallback();
                          }),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(LocalizationString.yourStory.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.w600))
                        ],
                      )
                    : Column(
                        children: [
                          MediaThumbnailView(
                            borderColor: stories[index].isViewed == true
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor,
                            media: stories[index].media.last,
                          ).ripple(() {
                            viewStoryCallback(stories[index]);
                          }),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Text(LocalizationString.yourStory.tr,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.w600)),
                          )
                        ],
                      )
                : Container(),
          );
        } else {
          if (index <= liveUsers.length) {
            return SizedBox(
                width: 70,
                child: Column(
                  children: [
                    UserAvatarView(
                      size: 50,
                      user: liveUsers[index - 1],
                      onTapHandler: () {
                        joinLiveUserCallback(liveUsers[index - 1]);
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                        child: Text(liveUsers[index - 1].userName,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontWeight: FontWeight.w600)).hP4)
                  ],
                ));
          } else {
            return SizedBox(
                width: 70,
                child: Column(
                  children: [
                    MediaThumbnailView(
                      borderColor:
                          stories[index - liveUsers.length].isViewed == true
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).primaryColor,
                      media: stories[index - liveUsers.length].media.last,
                    ).ripple(() {
                      viewStoryCallback(stories[index - liveUsers.length]);
                    }).ripple(() {
                      viewStoryCallback(stories[index - liveUsers.length]);
                    }),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: Text(stories[index - liveUsers.length].userName,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.w600)).hP4,
                    ),
                  ],
                ));
          }
        }
      },
    );
  }
}
