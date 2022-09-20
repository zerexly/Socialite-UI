import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class UserCard extends StatefulWidget {
  final UserModel model;
  final bool? canSelect;
  final bool? isSelected;
  final VoidCallback? selectionHandler;

  const UserCard(
      {Key? key,
      required this.model,
      this.canSelect,
      this.isSelected,
      this.selectionHandler})
      : super(key: key);

  @override
  UserCardState createState() => UserCardState();
}

class UserCardState extends State<UserCard> {
  late final UserModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black54),
          ),
          child: model.picture == null
              ? const Icon(Icons.error)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: model.picture!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        AppUtil.addProgressIndicator(context),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.userName,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w300)
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            model.country != null
                ? Text(
                    '${model.country},${model.city}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor),
                  )
                : Container(),
          ],
        ),
        const Spacer(),
        widget.canSelect == true
            ? ThemeIconWidget(
                widget.isSelected == true
                    ? ThemeIcon.checkMarkWithCircle
                    : ThemeIcon.circleOutline,
                color: Theme.of(context).primaryColor,
                size: 25,
              )
            : Container()
      ],
    ).ripple(
      () {
        if (widget.canSelect != true) {
          if (model.id == getIt<UserProfileManager>().user!.id) {
            Get.to(() => const UpdateProfile());
          } else {
            Get.to(() => OtherUserProfile(
                  userId: model.id,
                ));
          }
        }

        if (widget.selectionHandler != null) {
          widget.selectionHandler!();
        }
      },
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel profile;

  final VoidCallback? followCallback;
  final VoidCallback? unFollowCallback;
  final VoidCallback? viewCallback;
  final VoidCallback? openLiveCallback;

  final VoidCallback? chatCallback;
  final VoidCallback? audioCallCallback;
  final VoidCallback? videoCallCallback;

  final VoidCallback? sendCallback;

  const UserTile({
    Key? key,
    required this.profile,
    this.followCallback,
    this.unFollowCallback,
    this.viewCallback,
    this.openLiveCallback,
    this.chatCallback,
    this.audioCallCallback,
    this.videoCallCallback,
    this.sendCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAvatarView(
              user: profile,
              size: 40,
              onTapHandler: () {
                if (openLiveCallback != null) {
                  openLiveCallback!();
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ).bP4,
                profile.country != null
                    ? Text(
                        '${profile.city!}, ${profile.country!}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Container()
              ],
            ).hP16,
            // const Spacer(),
          ],
        ).ripple(() {
          if (viewCallback == null) {
            profileController.setUser(profile);
            Get.to(() => OtherUserProfile(userId: profile.id));
          } else {
            viewCallback!();
          }
        }),
        const Spacer(),
        followCallback != null
            ? SizedBox(
                height: 35,
                width: 120,
                child: profile.isFollowing == 0
                    ? BorderButtonType1(
                        // icon: ThemeIcon.message,
                        text: profile.isFollower == 1
                            ? LocalizationString.followBack
                            : LocalizationString.follow,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)
                            .copyWith(color: Theme.of(context).primaryColor),
                        onPress: () {
                          if (followCallback != null) {
                            followCallback!();
                          }
                        })
                    : FilledButtonType1(
                        isEnabled: true,
                        enabledTextStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)
                            .copyWith(color: Colors.white),
                        text: LocalizationString.unFollow,
                        onPress: () {
                          if (unFollowCallback != null) {
                            unFollowCallback!();
                          }
                        }),
              )
            : Container(),
        chatCallback != null
            ? Row(
                children: [
                  const ThemeIconWidget(
                    ThemeIcon.chat,
                    size: 20,
                  ).ripple(() {
                    chatCallback!();
                  }),
                  const ThemeIconWidget(
                    ThemeIcon.mobile,
                    size: 20,
                  ).hP16.ripple(() {
                    audioCallCallback!();
                  }),
                  const ThemeIconWidget(
                    ThemeIcon.videoCamera,
                    size: 20,
                  ).ripple(() {
                    videoCallCallback!();
                  }),
                ],
              )
            : Container(),
        sendCallback != null
            ? SizedBox(
                height: 30,
                width: 80,
                child: ProgressButton.icon(iconedButtons: {
                  ButtonState.idle: IconedButton(
                      text: "Send",
                      icon: const Icon(Icons.send, color: Colors.white),
                      color: Colors.deepPurple.shade500),
                  ButtonState.loading: IconedButton(
                      text: "Loading", color: Colors.deepPurple.shade700),
                  ButtonState.fail: IconedButton(
                      text: "Failed",
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      color: Colors.red.shade300),
                  ButtonState.success: IconedButton(
                      text: "Sent",
                      icon: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      color: Colors.green.shade400)
                }, onPressed: sendCallback, state: ButtonState.idle),
              )
            : Container()
      ],
    );
  }
}

class ForwardMessageUserTile extends StatelessWidget {
  final UserModel profile;
  final ButtonState state;
  final VoidCallback? viewCallback;
  final VoidCallback? sendCallback;

  const ForwardMessageUserTile({
    Key? key,
    required this.profile,
    required this.state,
    this.viewCallback,
    this.sendCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAvatarView(
              user: profile,
              size: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ).bP4,
                profile.country != null
                    ? Text(
                        profile.country!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Container()
              ],
            ).lP16,
            // const Spacer(),
          ],
        ).ripple(() {
          if (viewCallback == null) {
            profileController.setUser(profile);
            Get.to(() => OtherUserProfile(userId: profile.id));
          } else {
            viewCallback!();
          }
        }),
        const Spacer(),
        sendCallback != null
            ? AbsorbPointer(
                absorbing: state == ButtonState.success,
                child: SizedBox(
                  height: 30,
                  width: 80,
                  child: ProgressButton.icon(
                      radius: 5.0,
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                            text: LocalizationString.send,
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryIconTheme.color,
                              size: 15,
                            ),
                            color: Theme.of(context).primaryColor.lighten(0.4)),
                        ButtonState.loading: IconedButton(
                            text: LocalizationString.loading,
                            color: Theme.of(context).primaryColorLight),
                        ButtonState.fail: IconedButton(
                            text: LocalizationString.failed,
                            icon: Icon(Icons.cancel,
                                color: Theme.of(context).primaryIconTheme.color,
                                size: 15),
                            color: Theme.of(context).errorColor),
                        ButtonState.success: IconedButton(
                            text: LocalizationString.sent,
                            icon: Icon(Icons.check_circle,
                                color: Theme.of(context).primaryIconTheme.color,
                                size: 15),
                            color: Theme.of(context).primaryColor.darken())
                      },
                      onPressed: sendCallback,
                      state: state),
                ),
              )
            : Container()
      ],
    );
  }
}

class BlockedUserTile extends StatelessWidget {
  final UserModel profile;
  final VoidCallback? unBlockCallback;

  const BlockedUserTile({
    Key? key,
    required this.profile,
    this.unBlockCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAvatarView(
              user: profile,
              size: 40,
              onTapHandler: () {},
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600)
                      .copyWith(color: Theme.of(context).primaryColor),
                ).bP4,
                profile.country != null
                    ? Text(
                        profile.country!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Container()
              ],
            ).lP16,
          ],
        ),
        SizedBox(
            height: 35,
            width: 110,
            child: BorderButtonType1(
                // icon: ThemeIcon.message,
                text: LocalizationString.unblock,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)
                    .copyWith(color: Theme.of(context).primaryColor),
                onPress: () {
                  if (unBlockCallback != null) {
                    unBlockCallback!();
                  }
                }))
      ],
    );
  }
}
