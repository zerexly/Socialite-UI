import 'package:foap/helper/common_import.dart';

class HighlightsBar extends StatelessWidget {
  final List<HighlightsModel> highlights;
  final VoidCallback addHighlightCallback;
  final Function(HighlightsModel) viewHighlightCallback;

  const HighlightsBar(
      {Key? key,
      required this.highlights,
      required this.addHighlightCallback,
      required this.viewHighlightCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.separated(
          padding: const EdgeInsets.only(left: 16,right: 16),
          scrollDirection: Axis.horizontal,
          itemCount: highlights.length + 1,
          itemBuilder: (BuildContext ctx, int index) {
            if (index == 0) {
              return SizedBox(
                width: 70,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ThemeIconWidget(
                        ThemeIcon.plus,
                        size: 25,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ).borderWithRadius(context: context, value: 2, radius: 20),
                    const Spacer(),
                    Text(LocalizationString.add,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w600)),
                  ],
                ).ripple(() {
                  addHighlightCallback();
                }),
              );
            } else {
              return SizedBox(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: AvatarView(
                        url: highlights[index - 1].coverImage,
                      ).ripple(() {
                        viewHighlightCallback(highlights[index - 1]);
                      }),
                    ),
                    const Spacer(),
                    Text(
                      highlights[index - 1].name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ).hP4
                  ],
                ),
              );
            }
          },
          separatorBuilder: (BuildContext ctx, int index) {
            return const SizedBox(width: 10);
          }),
    );
  }
}
