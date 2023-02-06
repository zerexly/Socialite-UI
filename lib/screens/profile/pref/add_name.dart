import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../model/preference_model.dart';

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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            LocalizationString.nameHeader,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600),
          ).paddingOnly(top: 100),
          Text(
            LocalizationString.nameSubHeader,
            style: Theme.of(context).textTheme.titleSmall,
          ).paddingOnly(top: 20),
          InputField(
            hintText: 'Enter',
            controller: nameController,
            showBorder: true,
            borderColor: Theme.of(context).disabledColor,
            cornerRadius: 10,
          ).paddingOnly(top: 20),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    cornerRadius: 25,
                    text: LocalizationString.next,
                    onPress: () {
                      getIt<AddPreferenceManager>().preferenceModel?.name =
                          nameController.text;
                      Get.to(() => const AddPhotos());
                    })),
          ).paddingOnly(top: 150),
        ],
      ).hP25,
    );
  }
}
