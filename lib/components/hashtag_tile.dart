import 'package:foap/helper/common_import.dart';

class HashTagTile extends StatelessWidget {
  final Hashtag hashtag;
  final VoidCallback onItemCallback;

  const HashTagTile({
    Key? key,
    required this.hashtag,
    required this.onItemCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Center(
                  child: Text(
                '#',
                style: Theme.of(context).textTheme.displaySmall,
              )),
            ).borderWithRadius(context: context, value: 0.5, radius: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hashtag.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                ).bP4,
                Text(
                  '${hashtag.counter.formatNumber} ${LocalizationString.posts.toLowerCase()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ).hP16,
          ],
        ).vP16.ripple(() {
          onItemCallback();
        }),
      ],
    );
  }
}
