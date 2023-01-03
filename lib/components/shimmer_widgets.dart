import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return
            // index == 0
            //   ? const StoryAndHighlightsShimmer()
            //   :
            const PostCardShimmer().hP16;
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}

class ClubsCategoriesScreenShimmer extends StatelessWidget {
  const ClubsCategoriesScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: ListView.separated(
            padding: const EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext ctx, int index) {
              return SizedBox(
                width: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      height: Get.height,
                      width: Get.width,
                      color: Theme.of(context).cardColor,
                    ),
                    Positioned(
                        bottom: 5,
                        left: 5,
                        right: 5,
                        child: Text(
                          'Sports',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
              ).round(5).addShimmer(context);
            },
            separatorBuilder: (BuildContext ctx, int index) {
              return const SizedBox(
                width: 10,
              );
            }));
  }
}

class ClubsScreenShimmer extends StatelessWidget {
  const ClubsScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 5 * 350,
          child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16),
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctx, int index) {
                return Container(
                  // width: 250,
                  height: 320,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          width: Get.width,
                          height: double.infinity,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Club name',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ).p8,
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '250k ${LocalizationString.clubMembers}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          SizedBox(
                              height: 40,
                              width: 120,
                              child: FilledButtonType1(
                                  text: LocalizationString.join,
                                  onPress: () {}))
                        ],
                      ).setPadding(left: 12, right: 12, bottom: 20)
                    ],
                  ),
                ).round(15).addShimmer(context);
              },
              separatorBuilder: (BuildContext ctx, int index) {
                return const SizedBox(
                  height: 25,
                );
              }),
        ),
      ],
    ).bP16;
  }
}

class EventCategoriesScreenShimmer extends StatelessWidget {
  const EventCategoriesScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext ctx, int index) {
          return Row(
            children: [
              Container(
                color: Theme.of(context).cardColor,
                height: 30,
                width: 30,
              ).circular,
              const SizedBox(
                width: 10,
              ),
              Text(
                LocalizationString.loading,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              )
            ],
          )
              .setPadding(left: 8, right: 8, top: 4, bottom: 4)
              .borderWithRadius(context: context, value: 1, radius: 20);
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return const SizedBox(
            width: 10,
          );
        });
  }
}

class EventsScreenShimmer extends StatelessWidget {
  const EventsScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 5 * 350,
          child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16),
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctx, int index) {
                return Container(
                  // width: 250,
                  height: 320,
                  color: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          width: Get.width,
                          height: double.infinity,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Club name',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ).p8,
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '250k ${LocalizationString.clubMembers}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Spacer(),
                          SizedBox(
                              height: 40,
                              width: 120,
                              child: FilledButtonType1(
                                  text: LocalizationString.join,
                                  onPress: () {}))
                        ],
                      ).setPadding(left: 12, right: 12, bottom: 20)
                    ],
                  ),
                ).round(15).addShimmer(context);
              },
              separatorBuilder: (BuildContext ctx, int index) {
                return const SizedBox(
                  height: 25,
                );
              }),
        ),
      ],
    ).bP16;
  }
}

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset('assets/account.png'))
              .addShimmer(context),
          const SizedBox(width: 5),
          Expanded(
              child: Text(
            'Adam',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).primaryColor)
                .copyWith(fontWeight: FontWeight.w900),
          ).addShimmer(context)),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 280,
        width: double.infinity,
        child: Image.asset(
          'assets/tutorial1.jpg',
          fit: BoxFit.cover,
        ).addShimmer(context),
      ).round(20),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ThemeIconWidget(
            ThemeIcon.message,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(
            width: 5,
          ),
          Text('10k',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).primaryColor)
                      .copyWith(fontWeight: FontWeight.w900))
              .ripple(() {})
        ]),
        const SizedBox(
          width: 10,
        ),
        ThemeIconWidget(ThemeIcon.favFilled,
            color: Theme.of(context).errorColor),
        const SizedBox(
          width: 5,
        ),
        Text('205k',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w900)),
      ]).vP16.addShimmer(context),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
              'Lorem ipsum dolor sit amet. Et ipsa libero est dolor facilis qui distinctio neque. Sed dolorum accusamus qui tempora doloremque et suscipit quidem et voluptate'),
          const SizedBox(
            height: 10,
          ),
          Text('10 min ago',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
        ],
      ).addShimmer(context)
    ]);
  }
}

class StoryAndHighlightsShimmer extends StatelessWidget {
  const StoryAndHighlightsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext ctx, int index) {
            return Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  color: Theme.of(context).backgroundColor,
                ).round(10),
                const SizedBox(
                  height: 5,
                ),
                const Text('Adam')
              ],
            ).addShimmer(context);
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(width: 10);
          }),
    );
  }
}

class ShimmerUsers extends StatelessWidget {
  const ShimmerUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  color: Theme.of(context).primaryColor,
                ).round(10).addShimmer(context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adam',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).bP4,
                    Text(
                      'Canada',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ).lP16.addShimmer(context),
              ],
            ),
            SizedBox(
              height: 35,
              width: 110,
              child: BorderButtonType1(
                  // backgroundColor: Theme.of(context).cardColor,
                  text: LocalizationString.follow,
                  // cornerRadius: 10,
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                  onPress: () {}),
            ).addShimmer(context)
          ],
        );
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}

class ShimmerHashtag extends StatelessWidget {
  const ShimmerHashtag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (ctx, index) {
          return Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: Center(
                    child: Text(
                  '#',
                  style: Theme.of(context).textTheme.displaySmall,
                )),
              )
                  .borderWithRadius(context: context, value: 0.5, radius: 20)
                  .addShimmer(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#fun',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ).bP4,
                  Text(
                    '210k posts',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ).hP16.addShimmer(context),
            ],
          ).vP16;
        });
  }
}

class PostBoxShimmer extends StatelessWidget {
  const PostBoxShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      crossAxisCount: 3,
      itemCount: 50,
      itemBuilder: (BuildContext context, int index) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Theme.of(context).errorColor,
        ).round(10).addShimmer(context),
      ),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    ).hP16;
  }
}

class StoriesShimmerWidget extends StatelessWidget {
  const StoriesShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.6,
            crossAxisCount: 3),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).backgroundColor,
          ).round(10).addShimmer(context);
        }).hP16;
  }
}

class EventBookingShimmerWidget extends StatefulWidget {
  const EventBookingShimmerWidget({Key? key}) : super(key: key);

  @override
  State<EventBookingShimmerWidget> createState() =>
      _EventBookingShimmerWidgetState();
}

class _EventBookingShimmerWidgetState extends State<EventBookingShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
        itemCount: 20,
        itemBuilder: (BuildContext ctx, int index) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'National music festival',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Theme.of(context).cardColor,
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
                        '10-Nov-2022',
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
                        '10:00 AM',
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
                      'VIP',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
                  ).round(10)
                ],
              ).p16
            ],
          ).addShimmer(context);
        },
        separatorBuilder: (BuildContext ctx, int index) {
          return const SizedBox(
            height: 20,
          );
        });
  }
}
