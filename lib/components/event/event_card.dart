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
      width: Get.width * 0.8,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: event.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ).topRounded(10).ripple(() {
                  previewBtnClicked();
                }),
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Text(
                        '20 June 2022',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500),
                      ).p8,
                    ).round(20)),
                Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      child: Row(
                        children: [
                          ThemeIconWidget(
                            ThemeIcon.location,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'California',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w900),
                          ),
                        ],
                      ).p8,
                    ).round(20)),
                Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      color: Theme.of(context).cardColor,
                      height: 40,
                      width: 40,
                      child: ThemeIconWidget(
                        ThemeIcon.favFilled,
                        color: event.isFavourite ? Colors.red : Colors.white,
                      ).p4,
                    ).circular)
              ],
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Text(
            event.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w900),
          ).p8,
          // const SizedBox(
          //   height: 5,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${event.totalMembers.formatNumber} ${LocalizationString.clubMembers}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
            ],
          ).setPadding(left: 12, right: 12, bottom: 20)
        ],
      ),
    ).round(15);
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
      height: 150,
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: event.image,
            fit: BoxFit.cover,
            width: 100,
            height: double.infinity,
          ).round(15).ripple(() {
            previewBtnClicked();
          }),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '20 June 2022 10:20AM'.toUpperCase(),
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      event.name,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w900),
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
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'California',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${event.totalMembers.formatNumber} ${LocalizationString.going}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      color: Theme.of(context).backgroundColor,
                      height: 40,
                      width: 40,
                      child: ThemeIconWidget(
                        ThemeIcon.favFilled,
                        color: event.isFavourite ? Colors.red : Colors.white,
                      ).p4,
                    ).circular)
              ],
            ),
          ),
        ],
      ),
    ).round(15);
  }
}
