import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class WhatYouHope extends StatefulWidget {
  const WhatYouHope({Key? key}) : super(key: key);

  @override
  State<WhatYouHope> createState() => _WhatYouHopeState();
}

class _WhatYouHopeState extends State<WhatYouHope> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            'What are you hoping to find?',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Honesty helps you and everyone on Datefinder find what you\'re looking for',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            children: [
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('A relationship',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                    const Icon(Icons.circle_outlined),
                  ],
                ).hP25,
              ).round(10),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Something casual',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                    const Icon(Icons.circle_outlined),
                  ],
                ).hP25,
              ).round(10),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Not sure',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                    const Icon(Icons.circle_outlined),
                  ],
                ).hP25,
              ).round(10),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cant disclose',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                    const Icon(Icons.circle_outlined),
                  ],
                ).hP25,
              ).round(10)
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
                    text: LocalizationString.next,
                    onPress: () {
                      Get.to(() => const ChooseWhomToDate());
                    })),
          ),
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
