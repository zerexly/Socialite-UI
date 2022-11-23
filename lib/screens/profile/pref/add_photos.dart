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
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            'Add photos',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Profile with more good photos are getting more matches, so add your best photos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            children: [
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
              ),
              const SizedBox(
                height: 20,
              ),
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
              ),
            ],
          ),
          const SizedBox(
            height: 150,
          ),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    enabledTextStyle: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                    enabledBackgroundColor: Colors.white,
                    cornerRadius: 25,
                    text: 'Next',
                    onPress: () {
                      Get.to(() => const SetDateOfBirth());
                    })),
          ),
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
