import 'package:foap/helper/common_import.dart';

class ImageChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const ImageChatTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          // width: message.messageContentType == MessageContentType.photo
          //     ? double.infinity
          //     : null,
          height: 280,
          child:
              // message.media != null
              //     ? Stack(
              //         children: [
              //           message.media!.file != null
              //               ? Image.file(
              //                   message.media!.file!,
              //                   fit: BoxFit.cover,
              //                   height: double.infinity,
              //                   width: double.infinity,
              //                 )
              //               : Image.memory(
              //                   message.media!.mediaByte!,
              //                   fit: BoxFit.cover,
              //                   height: double.infinity,
              //                   width: double.infinity,
              //                 ),
              //           Positioned(
              //               child:
              //                   Center(child: AppUtil.addProgressIndicator(context))),
              //         ],
              //       )
              //     :
              MessageImage(
            message: message,
            fitMode: BoxFit.cover,
          ),
        ).round(10),
        message.messageStatusType == MessageStatus.sending
            ? Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child:
                    Center(child: AppUtil.addProgressIndicator(context, 100)))
            : Container()
      ],
    );
  }
}
