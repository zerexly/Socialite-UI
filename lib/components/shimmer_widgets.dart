import 'package:foap/helper/common_import.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20),
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return index == 0
            ? const StoryAndHighlightsShimmer()
            : const PostCardShimmer().hP16;
      },
      separatorBuilder: (ctx, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
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
