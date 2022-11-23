import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatMessageTile extends StatelessWidget {
  final ChatMessageModel message;
  final bool showName;
  final bool actionMode;
  final ChatDetailController chatDetailController = Get.find();
  final Function(ChatMessageModel) replyMessageTapHandler;
  final Function(ChatMessageModel) messageTapHandler;

  ChatMessageTile(
      {Key? key,
      required this.message,
      required this.showName,
      required this.actionMode,
      required this.replyMessageTapHandler,
      required this.messageTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return message.messageContentType == MessageContentType.groupAction
        ? ChatGroupActionCell(message: message)
        : Row(
            children: [
              actionMode
                  ? Obx(() => Row(
                        children: [
                          ThemeIconWidget(
                            chatDetailController.isSelected(message)
                                ? ThemeIcon.checkMarkWithCircle
                                : ThemeIcon.circleOutline,
                            size: 20,
                            color: Theme.of(context).disabledColor,
                          ).ripple(() {
                            chatDetailController.selectMessage(message);
                          }),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ))
                  : Container(),
              // message.isMineMessage ? const Spacer() : Container(),
              Expanded(
                child: Container(
                  color: message.messageContentType == MessageContentType.gif ||
                          message.messageContentType ==
                              MessageContentType.sticker
                      ? Colors.transparent
                      : message.isMineMessage
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor.darken(0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showName ? nameWidget(context) : Container(),
                      message.messageContentType ==
                                  MessageContentType.forward &&
                              message.isMineMessage == false
                          ? Row(
                              children: [
                                ThemeIconWidget(
                                  ThemeIcon.fwd,
                                  size: 15,
                                  color: Theme.of(context).iconTheme.color,
                                ).rP4,
                                Text(
                                  LocalizationString.forward,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(
                        height: 5,
                      ),
                      message.isDeleted == 1
                          ? deletedMessageWidget()
                          : message.isReply
                              ? replyContentWidget()
                              : contentWidget(message).ripple(() {
                                  messageTapHandler(message);
                                }),
                      const SizedBox(
                        height: 5,
                      ),
                      MessageDeliveryStatusView(message: message),
                    ],
                  ).p8,
                ).round(10).setPadding(
                    left: message.isMineMessage ? 50 : 0,
                    right: message.isMineMessage ? 0 : 50),
              ),
              // message.isMineMessage ? Container() : const Spacer(),
            ],
          );
  }

  Widget deletedMessageWidget() {
    return DeletedMessageChatTile(message: message);
  }

  Widget replyContentWidget() {
    if (message.reply.messageContentType == MessageContentType.text) {
      return ReplyTextChatTile(
        message: message,
        messageTapHandler: messageTapHandler,
        replyMessageTapHandler: replyMessageTapHandler,
      );
    } else if (message.reply.messageContentType == MessageContentType.photo) {
      return ReplyImageChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.gif) {
      return ReplyStickerChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.video) {
      return ReplyVideoChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.audio) {
      return ReplyAudioChatTile(
          message: message, replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.contact) {
      return ReplyContactChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType ==
        MessageContentType.location) {
      return ReplyLocationChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.profile) {
      return ReplyUserProfileChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    } else if (message.reply.messageContentType == MessageContentType.reply) {
      return ReplyFileChatTile(
          message: message,
          messageTapHandler: messageTapHandler,
          replyMessageTapHandler: replyMessageTapHandler);
    }
    return TextChatTile(message: message);
  }

  Widget contentWidget(ChatMessageModel messageModel) {
    if (messageModel.messageContentType == MessageContentType.text) {
      return TextChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.photo) {
      return ImageChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.gif) {
      return StickerChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.video) {
      return VideoChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.audio) {
      return AudioChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.post) {
      return PostChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.location) {
      return LocationChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.forward) {
      return contentWidget(messageModel.originalMessage);
    } else if (messageModel.messageContentType == MessageContentType.contact) {
      return ContactChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.profile) {
      return UserProfileChatTile(message: messageModel);
    } else if (messageModel.messageContentType == MessageContentType.file) {
      return FileChatTile(message: messageModel);
    }
    return TextChatTile(message: message);
  }

  Widget nameWidget(BuildContext context) {
    return Text(
      message.userName,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900),
    );
  }
}

class MessageDeliveryStatusView extends StatelessWidget {
  final ChatMessageModel message;

  const MessageDeliveryStatusView({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatDetailController chatDetailController = Get.find();

    return VisibilityDetector(
        key: UniqueKey(),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;

          if (!message.isMineMessage && visiblePercentage > 90) {
            if (message.messageStatusType != MessageStatus.read &&
                message.messageContentType != MessageContentType.groupAction &&
                !message.isDateSeparator) {
              chatDetailController.sendMessageAsRead(message);
              message.status = 3;
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            message.isStar == 1
                ? ThemeIconWidget(
                    ThemeIcon.filledStar,
                    color: Theme.of(context).primaryColor,
                    size: 15,
                  ).rP4
                : Container(),
            Text(
              message.messageTime,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              width: 5,
            ),
            message.isMineMessage
                ? ThemeIconWidget(
                    message.messageStatusType == MessageStatus.sent
                        ? ThemeIcon.sent
                        : message.messageStatusType == MessageStatus.delivered
                            ? ThemeIcon.delivered
                            : message.messageStatusType == MessageStatus.read
                                ? ThemeIcon.read
                                : ThemeIcon.sending,
                    size: 15,
                    color: message.messageStatusType == MessageStatus.read
                        ? Colors.blue
                        : Theme.of(context).iconTheme.color,
                  )
                : Container(),
          ],
        ));
  }
}
