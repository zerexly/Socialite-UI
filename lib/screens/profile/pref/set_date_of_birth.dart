import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class SetDateOfBirth extends StatefulWidget {
  const SetDateOfBirth({Key? key}) : super(key: key);

  @override
  State<SetDateOfBirth> createState() => _SetDateOfBirthState();
}

class _SetDateOfBirthState extends State<SetDateOfBirth> {
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
            'When\'s your birthday?',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Be accurate to specify this to get genuine matchs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 60,
                    child: InputField(
                      hintText: '10',
                      controller: nameController,
                      backgroundColor: Colors.white,
                      cornerRadius: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Month',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 60,
                    child: InputField(
                      hintText: '07',
                      controller: nameController,
                      backgroundColor: Colors.white,
                      cornerRadius: 5,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Year',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 60,
                    child: InputField(
                      hintText: '2000',
                      controller: nameController,
                      backgroundColor: Colors.white,
                      cornerRadius: 5,
                    ),
                  ),
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
                      Get.to(() => const SetYourGender());
                    })),
          ),
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
