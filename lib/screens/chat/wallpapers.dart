import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class WallpaperForChatBackground extends StatefulWidget {
  final int opponentId;

  const WallpaperForChatBackground({Key? key, required this.opponentId})
      : super(key: key);

  @override
  State<WallpaperForChatBackground> createState() =>
      _WallpaperForChatBackgroundState();
}

class _WallpaperForChatBackgroundState
    extends State<WallpaperForChatBackground> {
  List<String> wallpapers = [
    'assets/chatbg/chatbg1.jpg',
    'assets/chatbg/chatbg2.jpg',
    'assets/chatbg/chatbg3.jpg',
    'assets/chatbg/chatbg4.jpg',
    'assets/chatbg/chatbg5.jpg',
    'assets/chatbg/chatbg6.jpg',
    'assets/chatbg/chatbg7.jpg',
    'assets/chatbg/chatbg8.jpg',
    'assets/chatbg/chatbg9.jpg',
    'assets/chatbg/chatbg10.jpg',
    'assets/chatbg/chatbg11.jpg',
    'assets/chatbg/chatbg12.jpg',
    'assets/chatbg/chatbg13.jpg',

  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).primaryColor,
                size: 27,
              ).ripple(() {
                Get.back();
              }),
              const Spacer(),
              Text(
                LocalizationString.wallpapers,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              const SizedBox(
                width: 27,
              )
            ],
          ).hp(20),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.6,
                    crossAxisCount: 3),
                itemCount: wallpapers.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    wallpapers[index],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ).round(5).ripple(() {
                    SharedPrefs().setWallpaper(
                        userId: widget.opponentId,
                        wallpaper: wallpapers[index]);
                  });
                }).hP16,
          )
        ],
      ),
    );
  }
}
