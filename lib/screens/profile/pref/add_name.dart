import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class AddName extends StatefulWidget {
  const AddName({Key? key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
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
            'What\'s you first name?',
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'You won\'t be able to change this later',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 50,
          ),
          InputField(
            hintText: 'Alex',
            controller: nameController,
            backgroundColor: Colors.white,
            cornerRadius: 20,
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
                      Get.to(() => const AddPhotos());
                    })),
          ),
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
