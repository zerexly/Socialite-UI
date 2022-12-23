import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class Reels extends StatefulWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  final ReelsController _reelsController = Get.find();

  @override
  void initState() {
    super.initState();
    _reelsController.getReels();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            GetBuilder<ReelsController>(
                init: _reelsController,
                builder: (ctx) {
                  return PageView(
                      scrollDirection: Axis.vertical,
                      allowImplicitScrolling: true,
                      onPageChanged: (index) {
                        _reelsController.currentPageChanged(
                            index, _reelsController.reels[index]);
                      },
                      children: [
                        for (int i = 0; i < _reelsController.reels.length; i++)
                          SizedBox(
                            height: Get.height,
                            width: Get.width,
                            // color: Colors.brown,
                            child: ReelVideoPlayer(
                              reel: _reelsController.reels[i],
                              // play: false,
                            ),
                          )
                      ]);
                }),
          ],
        ));
  }
}
