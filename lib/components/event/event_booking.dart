import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookingModel.event.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  bookingModel.giftedToUser != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  LocalizationString.giftedTo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  bookingModel.giftedByUser!.userName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const ThemeIconWidget(
                                  ThemeIcon.nextArrow,
                                  size: 15,
                                )
                              ],
                            ),
                            Container(
                              height: 2,
                              width: 60,
                              color: Theme.of(context).primaryColor,
                            ).vP4,
                          ],
                        ).tP8.ripple(() {
                          Get.to(() => OtherUserProfile(
                              userId: bookingModel.giftedByUser!.id));
                        })
                      : Container(),
                  bookingModel.giftedByUser != null &&
                          bookingModel.giftedByUser?.isMe == false
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  LocalizationString.giftedBy,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  bookingModel.giftedByUser!.userName,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const ThemeIconWidget(
                                  ThemeIcon.nextArrow,
                                  size: 15,
                                )
                              ],
                            ),
                            Container(
                              height: 2,
                              width: 60,
                              color: Theme.of(context).primaryColor,
                            ).vP4,
                          ],
                        ).tP8.ripple(() {
                          Get.to(() => OtherUserProfile(
                              userId: bookingModel.giftedByUser!.id));
                        })
                      : Container(),
                ],
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
