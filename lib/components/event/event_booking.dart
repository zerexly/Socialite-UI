import 'package:foap/helper/common_import.dart';

class EventBookingCard extends StatelessWidget {
  final EventBookingModel bookingModel;

  const EventBookingCard({Key? key, required this.bookingModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                bookingModel.event.name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            CachedNetworkImage(
              imageUrl: bookingModel.event.image,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ).round(10)
          ],
        ).p16,
        divider(context: context).vP8,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationString.date,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 2,
                  width: 30,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  bookingModel.event.startAtDate,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationString.time,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 2,
                  width: 30,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  bookingModel.event.startAtTime,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                )
              ],
            ),
            const Spacer(),
            Container(
              color: Theme.of(context).backgroundColor,
              child: Text(
                bookingModel.ticketType.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
            ).round(10)
          ],
        ).p16
      ],
    ).shadow(context: context, radius: 15);
  }
}
