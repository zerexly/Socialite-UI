import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CommentTile extends StatefulWidget {
  final CommentModel model;

  const CommentTile({Key? key, required this.model}) : super(key: key);

  @override
  CommentTileState createState() => CommentTileState();
}

class CommentTileState extends State<CommentTile> {
  late final CommentModel model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  child: InkWell(
                      onTap: () {
                        Get.to(() => OtherUserProfile(userId: model.userId));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AvatarView(url: model.userPicture, name: model.userName,size: 35,),
                          const SizedBox(width: 10),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                model.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w900),
                              ),
                              Text(
                                model.comment,
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            ],
                          ))
                        ],
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(model.commentTime,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w600)))
            ]);
  }
}
