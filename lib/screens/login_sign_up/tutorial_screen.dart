import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  TutorialScreenState createState() => TutorialScreenState();
}

class TutorialScreenState extends State<TutorialScreen> {
  int _current = 0;
  List<String> imgList = [
    "assets/tutorial1.jpg",
    "assets/tutorial2.jpg",
    "assets/tutorial3.jpg",
    "assets/tutorial4.jpg",
  ];

  List<String> headings = [
    "Post",
    "Chat",
    "Calls",
    "Live"
  ];

  List<String> subHeadings = [
    "Join us and share you life experience, Post picture and videos",
    "Have conversations with friends, with text,image,video,audio,gif,stickers etc messages",
    "Audio and video to talk long with your friends and family",
    "Go live with your followers to share",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // appBar: AppBar(
        //     backgroundColor: Theme.of(context).backgroundColor,
        //     centerTitle: true,
        //     elevation: 0.0,
        //     title: Image.asset(
        //       'assets/logo.png',
        //       width: 80,
        //       height: 25,
        //     )),
        body: Column(children: [
          Expanded(
            child: CarouselSlider(
              items: addImages(),
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  height: double.infinity,
                  viewportFraction: 1,
                  // height: MediaQuery.of(context).size.height / 1.5,
                  // aspectRatio: 0.7,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((url) {
              int index = imgList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
              );
            }).toList(),
          ),
          Text(headings[_current],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor)
                      .copyWith(fontWeight: FontWeight.w900))
              .setPadding(left: 50, right: 50),
          const SizedBox(
            height: 16,
          ),
          Text(subHeadings[_current],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge)
              .setPadding(left: 25, right: 25),
          const SizedBox(
            height: 52,
          ),
          addActionBtn(),
          const SizedBox(
            height: 56,
          ),
        ]));
  }

  List<Widget> addImages() {
    return imgList
        .map((item) => SizedBox(
              height: double.infinity,
              child: Image.asset(
                item,
                fit: BoxFit.cover,
                width: 1000.0,
                height: double.infinity,
              ),
            ))
        .toList();
  }

  addActionBtn() {
    return FilledButtonType1(
      onPress: () {
        Get.to(() => const SignUpScreen());
      },
      text: LocalizationString.signUp,
      enabledTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
      isEnabled: true,
    ).hP25;
  }
}
