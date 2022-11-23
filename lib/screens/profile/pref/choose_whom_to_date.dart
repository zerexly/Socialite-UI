import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class ChooseWhomToDate extends StatefulWidget {
  const ChooseWhomToDate({Key? key}) : super(key: key);

  @override
  State<ChooseWhomToDate> createState() => _ChooseWhomToDateState();
}

class _ChooseWhomToDateState extends State<ChooseWhomToDate> {
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
            'Who would you like to date?',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'You can choose more than one answer and change any time',
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
                    Text('Open to all',
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
                    Text('Male',
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
                    Text('Female',
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
                    Text('Transgender',
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
                    text: 'Next',
                    onPress: () {
                      Get.to(() => const ChooseGoal());
                    })),
          ),
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
