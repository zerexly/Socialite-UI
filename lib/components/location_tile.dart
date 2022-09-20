import 'package:foap/helper/common_import.dart';

class LocationTile extends StatelessWidget {
  final LocationModel location;
  final VoidCallback onItemCallback;

  const LocationTile({
    Key? key,
    required this.location,
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
              child: ThemeIconWidget(
                ThemeIcon.addressPin,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ).borderWithRadius(context: context, value: 0.5, radius: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                ).bP4,
                Text(
                  '1.50k posts',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ).hP16,
          ],
        ).p16.ripple(() {
          onItemCallback();
        }),
      ],
    );
  }
}
