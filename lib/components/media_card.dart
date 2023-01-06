import '../helper/common_import.dart';

class MediaCard extends StatelessWidget {
  final MediaModel model;

  const MediaCard({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CachedNetworkImage(
            imageUrl: model.image ?? '',
            fit: BoxFit.cover,
            height: 110,
          ).round(12),
          Text(
            model.name ?? '',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w300),
          ).setPadding(top: 12, bottom: 6),
          Text(
            model.showTime ?? '',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w300),
          ),
        ],
      ).p(12),
    ).round(15);
  }
}

class MediaModel {
  String? name;
  String? image;
  String? showTime;

  MediaModel(this.name, this.image, this.showTime);
}
