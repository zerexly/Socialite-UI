import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../model/club_join_request.dart';

class UserInfo extends StatelessWidget {
  final UserModel model;

  const UserInfo({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatarView(
          user: model,
          size: 50,
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
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 5,
            ),
            model.country != null
                ? Text(
                    '${model.country},${model.city}',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}

class SelectableUserCard extends StatefulWidget {
  final UserModel model;
  final bool isSelected;
  final VoidCallback? selectionHandler;

  const SelectableUserCard(
      {Key? key,
      required this.model,
      required this.isSelected,
      this.selectionHandler})
      : super(key: key);

  @override
  SelectableUserCardState createState() => SelectableUserCardState();
}

class SelectableUserCardState extends State<SelectableUserCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            children: [
              UserAvatarView(
                user: widget.model,
                size: 50,
              ),
              widget.isSelected == true
                  ? Positioned(
                      child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.black45,
                      child: const Center(
                        child: ThemeIconWidget(
                          ThemeIcon.checkMark,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ).round(15))
                  : Container()
            ],
          ).ripple(
            () {
              widget.selectionHandler!();
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.model.userName,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}

class SelectableUserTile extends StatefulWidget {
  final UserModel model;
  final bool? canSelect;
  final bool? isSelected;
  final VoidCallback? selectionHandler;

  const SelectableUserTile(
      {Key? key,
      required this.model,
      this.canSelect,
      this.isSelected,
      this.selectionHandler})
      : super(key: key);

  @override
  SelectableUserTileState createState() => SelectableUserTileState();
}

class SelectableUserTileState extends State<SelectableUserTile> {
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
        UserInfo(model: model),
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
    this.chatCallback,
    this.audioCallCallback,
    this.videoCallCallback,
    this.sendCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final AgoraLiveController agoraLiveController = Get.find();
    final SettingsController settingsController = Get.find();

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
                Live live = Live(
                    channelName: profile.liveCallDetail!.channelName,
                    isHosting: false,
                    host: profile,
                    token: profile.liveCallDetail!.token,
                    liveId: profile.liveCallDetail!.id);
                agoraLiveController.joinAsAudience(
                  live: live,
                );
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ).bP4,
                  profile.country != null
                      ? Text(
                          '${profile.city!}, ${profile.country!}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : Container()
                ],
              ).hP16,
            ),
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
        if (followCallback != null && profile.isMe == false)
          SizedBox(
            height: 35,
            width: 120,
            child: profile.isFollowing == false
                ? BorderButtonType1(
                    // icon: ThemeIcon.message,
                    text: profile.isFollower == true
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
          ),
        if (chatCallback != null)
          Row(
            children: [
              if (settingsController.setting.value!.enableChat)
                const ThemeIconWidget(
                  ThemeIcon.chat,
                  size: 20,
                ).rP16.ripple(() {
                  chatCallback!();
                }),
              if (settingsController.setting.value!.enableAudioCalling)
                const ThemeIconWidget(
                  ThemeIcon.mobile,
                  size: 20,
                ).rP16.ripple(() {
                  audioCallCallback!();
                }),
              if (settingsController.setting.value!.enableVideoCalling)
                const ThemeIconWidget(
                  ThemeIcon.videoCamera,
                  size: 20,
                ).ripple(() {
                  videoCallCallback!();
                }),
            ],
          ),
        if (sendCallback != null)
          SizedBox(
            height: 30,
            width: 80,
            child: ProgressButton.icon(iconedButtons: {
              ButtonState.idle: IconedButton(
                  text: LocalizationString.send,
                  icon: const Icon(Icons.send, color: Colors.white),
                  color: Colors.deepPurple.shade500),
              ButtonState.loading: IconedButton(
                  text: LocalizationString.loading,
                  color: Colors.deepPurple.shade700),
              ButtonState.fail: IconedButton(
                  text: LocalizationString.failed,
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  color: Colors.red.shade300),
              ButtonState.success: IconedButton(
                  text: LocalizationString.sent,
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  color: Colors.green.shade400)
            }, onPressed: sendCallback, state: ButtonState.idle),
          )
      ],
    );
  }
}

class RelationUserTile extends StatelessWidget {
  final UserModel profile;

  final Function(int)? inviteCallback;
  final Function(int)? unInviteCallback;
  final VoidCallback? viewCallback;

  const RelationUserTile({
    Key? key,
    required this.profile,
    this.inviteCallback,
    this.unInviteCallback,
    this.viewCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();
    final AgoraLiveController agoraLiveController = Get.find();

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
                Live live = Live(
                    channelName: profile.liveCallDetail!.channelName,
                    isHosting: false,
                    host: profile,
                    token: profile.liveCallDetail!.token,
                    liveId: profile.liveCallDetail!.id);
                agoraLiveController.joinAsAudience(
                  live: live,
                );
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ).bP4,
                  profile.country != null
                      ? Text(
                    '${profile.city!}, ${profile.country!}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                      : Container()
                ],
              ).hP16,
            ),
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
        if (inviteCallback != null && profile.isMe == false)
          SizedBox(
            height: 35,
            width: 120,
            child:  BorderButtonType1(
              // icon: ThemeIcon.message,
                text: LocalizationString.invite,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600)
                    .copyWith(color: Theme.of(context).primaryColor),
                onPress: () {
                  if (inviteCallback != null) {
                    inviteCallback!(profile.id);
                  }
                })
            ,
          ),
      ],
    );
  }
}


class ClubMemberTile extends StatelessWidget {
  final ClubMemberModel member;
  final VoidCallback? removeBtnCallback;
  final VoidCallback? viewCallback;

  const ClubMemberTile({
    Key? key,
    required this.member,
    this.removeBtnCallback,
    this.viewCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgoraLiveController agoraLiveController = Get.find();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAvatarView(
              user: member.user!,
              size: 40,
              onTapHandler: () {
                Live live = Live(
                    channelName: member.user!.liveCallDetail!.channelName,
                    isHosting: false,
                    host: member.user!,
                    token: member.user!.liveCallDetail!.token,
                    liveId: member.user!.liveCallDetail!.id);
                agoraLiveController.joinAsAudience(
                  live: live,
                );
              },
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.user!.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ).bP4,
                  member.user!.country != null
                      ? Text(
                          '${member.user!.city!}, ${member.user!.country!}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : Container()
                ],
              ).hP16,
            ).ripple(() {
              if (viewCallback != null) {
                viewCallback!();
              }
            }),
            // const Spacer(),
          ],
        ),
        const Spacer(),
        member.isAdmin == 1
            ? SizedBox(
                height: 35,
                width: 120,
                child: Center(
                  child: Text(
                    LocalizationString.admin,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            : removeBtnCallback != null
                ? SizedBox(
                    height: 35,
                    width: 120,
                    child: FilledButtonType1(
                        // icon: ThemeIcon.message,
                        text: LocalizationString.remove,
                        enabledTextStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)
                            .copyWith(color: Theme.of(context).primaryColor),
                        onPress: () {
                          if (removeBtnCallback != null) {
                            removeBtnCallback!();
                          }
                        }),
                  )
                : Container(),
      ],
    );
  }
}

class EventMemberTile extends StatelessWidget {
  final EventMemberModel member;
  final VoidCallback? viewCallback;

  const EventMemberTile({
    Key? key,
    required this.member,
    this.viewCallback,
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
              user: member.user!,
              size: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.user!.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ).bP4,
                  member.user!.country != null
                      ? Text(
                          '${member.user!.city!}, ${member.user!.country!}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : Container()
                ],
              ).hP16,
            ).ripple(() {
              if (viewCallback != null) {
                viewCallback!();
              }
            }),
            // const Spacer(),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class SendMessageUserTile extends StatelessWidget {
  final UserModel profile;
  final ButtonState state;
  final VoidCallback? viewCallback;
  final VoidCallback? sendCallback;

  const SendMessageUserTile({
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
        UserInfo(model: profile).ripple(() {
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
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 15,
                            ),
                            color: Theme.of(context).primaryColor.lighten(0.1)),
                        ButtonState.loading: IconedButton(
                            text: LocalizationString.loading,
                            color: Colors.white),
                        ButtonState.fail: IconedButton(
                            text: LocalizationString.failed,
                            icon: const Icon(Icons.cancel,
                                color: Colors.white, size: 15),
                            color: Theme.of(context).errorColor),
                        ButtonState.success: IconedButton(
                            text: LocalizationString.sent,
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white, size: 15),
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
        UserInfo(model: profile),
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

class GifterUserTile extends StatelessWidget {
  final ReceivedGiftModel gift;

  const GifterUserTile({Key? key, required this.gift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserInfo(model: gift.sender),
        const Spacer(),
        CachedNetworkImage(
          imageUrl: gift.giftDetail.logo,
          height: 40,
          width: 40,
        ),
        const SizedBox(
          width: 5,
        ),
        const ThemeIconWidget(
          ThemeIcon.diamond,
          color: Colors.yellow,
          size: 18,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          gift.giftDetail.coins.toString(),
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}

class ClubJoinRequestTile extends StatelessWidget {
  final ClubJoinRequest request;
  final VoidCallback acceptBtnClicked;
  final VoidCallback declineBtnClicked;
  final VoidCallback viewCallback;

  const ClubJoinRequestTile({
    Key? key,
    required this.request,
    required this.viewCallback,
    required this.acceptBtnClicked,
    required this.declineBtnClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgoraLiveController agoraLiveController = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserAvatarView(
              user: request.user!,
              hideLiveIndicator: true,
              size: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.user!.userName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900),
                  ).bP4,
                  request.user!.country != null
                      ? Text(
                          '${request.user!.city!}, ${request.user!.country!}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : Container()
                ],
              ).hP16,
            ),
            // const Spacer(),
          ],
        ).ripple(() {
          viewCallback();
        }),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
                height: 35,
                width: 120,
                child: FilledButtonType1(
                    // icon: ThemeIcon.message,
                    text: LocalizationString.accept,
                    enabledTextStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                    onPress: () {
                      acceptBtnClicked();
                    })),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                height: 35,
                width: 120,
                child: BorderButtonType1(
                    // icon: ThemeIcon.message,
                    text: LocalizationString.decline,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600)
                        .copyWith(color: Theme.of(context).primaryColor),
                    onPress: () {
                      declineBtnClicked();
                    })),
          ],
        ),
      ],
    );
  }
}