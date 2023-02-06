import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class AddPhotos extends StatefulWidget {
  const AddPhotos({Key? key}) : super(key: key);

  @override
  State<AddPhotos> createState() => _AddPhotosState();
}

class _AddPhotosState extends State<AddPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationString.addPhotoHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            Text(
              LocalizationString.addPhotoSubHeader,
              style: Theme.of(context).textTheme.titleSmall,
            ).paddingOnly(top: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                ).round(10),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                ).round(10),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                ).round(10)
              ],
            ).paddingOnly(top: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                ).round(10),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                ).round(10),
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: const Icon(
                    Icons.add,
                    size: 25,
                  ),
                ).round(10)
              ],
            ).paddingOnly(top: 20),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        Get.to(() => const SetDateOfBirth());
                      })),
            ).paddingOnly(top: 110),
          ],
        ).hP25,
      ),
    );
  }
}
