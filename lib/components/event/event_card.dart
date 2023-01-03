import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const EventCard(
      {Key? key,
      required this.event,
      required this.joinBtnClicked,
      required this.leaveBtnClicked,
      required this.previewBtnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.5,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: event.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: Get.width * 0.4,
              ).round(25).ripple(() {
                previewBtnClicked();
              }),
              if (event.isFree)
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Text(LocalizationString.free).p4,
                    ).round(5))
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            event.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            event.startAtDateTime,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              ThemeIconWidget(
                ThemeIcon.location,
                color: Theme.of(context).primaryColor,
                size: 17,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                event.placeName,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w300),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '${event.totalMembers.formatNumber} ${LocalizationString.clubMembers}',
          //       style: Theme.of(context).textTheme.bodyLarge,
          //     ),
          //     const Spacer(),
          //   ],
          // ).setPadding(left: 12, right: 12, bottom: 20)
        ],
      ).p(12),
    ).round(25);
  }
}

class EventCard2 extends StatelessWidget {
  final EventModel event;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const EventCard2(
      {Key? key,
      required this.event,
      required this.joinBtnClicked,
      required this.leaveBtnClicked,
      required this.previewBtnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: event.image,
                fit: BoxFit.cover,
                width: 120,
                height: double.infinity,
              ).round(15).ripple(() {
                previewBtnClicked();
              }),
              if (event.isFree)
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Text(LocalizationString.free).p4,
                    ).round(5))
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      event.startAtDateTime.toUpperCase(),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ThemeIconWidget(
                          ThemeIcon.location,
                          color: Theme.of(context).primaryColor,
                          size: 17,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          event.placeName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   '${event.totalMembers.formatNumber} ${LocalizationString.going}',
                    //   style: Theme.of(context).textTheme.bodyLarge,
                    // ),
                  ],
                ),
                // Positioned(
                //     right: 10,
                //     top: 10,
                //     child: Container(
                //       color: Theme.of(context).backgroundColor,
                //       height: 40,
                //       width: 40,
                //       child: ThemeIconWidget(
                //         ThemeIcon.favFilled,
                //         color: event.isFavourite ? Colors.red : Colors.white,
                //       ).p4,
                //     ).circular)
              ],
            ),
          ),
        ],
      ).p(12),
    ).round(25);
  }
}
