import 'package:foap/helper/common_import.dart';

Widget messageTypeShortInfo({
  required ChatMessageModel message,
  required BuildContext context,
}) {
  return message.messageContentType == MessageContentType.reply
      ? messageTypeShortInfoFromType(
          type: message.messageReplyContentType,
          message: message,
          context: context,
        )
      : messageTypeShortInfoFromType(
          message: message, type: message.messageContentType, context: context);
}

Widget messageTypeShortInfoFromType({
  required ChatMessageModel message,
  required MessageContentType type,
  required BuildContext context,
}) {
  return type == MessageContentType.text
      ? Text(
          message.textMessage,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      : type == MessageContentType.photo
          ? Row(
              children: [
                const ThemeIconWidget(
                  ThemeIcon.camera,
                  size: 12,
                ).rP4,
                Text(
                  LocalizationString.photo,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ],
            )
          : type == MessageContentType.video
              ? Row(
                  children: [
                    const ThemeIconWidget(ThemeIcon.videoPost, size: 15).rP4,
                    Text(
                      LocalizationString.video,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              : type == MessageContentType.gif ||
                      type == MessageContentType.sticker
                  ? Row(
                      children: [
                        const ThemeIconWidget(ThemeIcon.gif, size: 15).rP4,
                        Text(
                          LocalizationString.gif,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  : type == MessageContentType.post
                      ? Row(
                          children: [
                            const ThemeIconWidget(
                              ThemeIcon.camera,
                              size: 15,
                            ).rP4,
                            Text(
                              LocalizationString.post,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      : type == MessageContentType.audio
                          ? Row(
                              children: [
                                const ThemeIconWidget(ThemeIcon.mic, size: 15)
                                    .rP4,
                                Text(
                                  LocalizationString.audio,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w300),
                                ),
                              ],
                            )
                          : type == MessageContentType.contact
                              ? Row(
                                  children: [
                                    const ThemeIconWidget(ThemeIcon.contacts,
                                            size: 15)
                                        .rP4,
                                    Text(
                                      LocalizationString.contact,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                )
                              : type == MessageContentType.location
                                  ? Row(
                                      children: [
                                        const ThemeIconWidget(
                                                ThemeIcon.location,
                                                size: 15)
                                            .rP4,
                                        Text(
                                          LocalizationString.location,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    )
                                  : type == MessageContentType.file
                                      ? Row(
                                          children: [
                                            const ThemeIconWidget(
                                                    ThemeIcon.files,
                                                    size: 15)
                                                .rP4,
                                            Text(
                                              LocalizationString.file,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300),
                                            ),
                                          ],
                                        )
                                      : type == MessageContentType.profile
                                          ? Row(
                                              children: [
                                                const ThemeIconWidget(
                                                        ThemeIcon.account,
                                                        size: 15)
                                                    .rP4,
                                                Text(
                                                  LocalizationString.profile,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w300),
                                                ),
                                              ],
                                            )
                                          : Container();
}

Widget messageMainContent(ChatMessageModel message) {
  if (message.messageContentType == MessageContentType.forward) {
    return messageMainContent(message.originalMessage);
  }

  return message.messageContentType == MessageContentType.text
      ? Container()
      : message.messageContentType == MessageContentType.photo
          ? SizedBox(
              height: 60, width: 60, child: ImageChatTile(message: message).p8)
          : message.messageContentType == MessageContentType.video
              ? SizedBox(
                  height: 60,
                  width: 60,
                  child: VideoChatTile(
                    message: message,
                    showSmall: true,
                  ).p8)
              : message.messageContentType == MessageContentType.gif ||
                      message.messageContentType == MessageContentType.sticker
                  ? SizedBox(
                      height: 60,
                      width: 60,
                      child: StickerChatTile(message: message).p8)
                  : message.messageContentType == MessageContentType.post
                      ? SizedBox(
                          height: 60,
                          width: 60,
                          child: MinimalInfoPostChatTile(message: message).p8)
                      : message.messageContentType ==
                              MessageContentType.location
                          ? SizedBox(
                              height: 60,
                              width: 60,
                              child: LocationChatTile(message: message).p8)
                          : Container();
}
