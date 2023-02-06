import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../../controllers/profile/set_profile_category_controller.dart';

class SetProfileCategoryType extends StatefulWidget {
  final bool isFromSignup;

  const SetProfileCategoryType({Key? key, required this.isFromSignup})
      : super(key: key);

  @override
  State<SetProfileCategoryType> createState() => _SetProfileCategoryTypeState();
}

class _SetProfileCategoryTypeState extends State<SetProfileCategoryType> {
  final SetProfileCategoryController _setProfileCategoryController =
      SetProfileCategoryController();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isFromSignup == true)
            const SizedBox(
              height: 70,
            ),
          if (widget.isFromSignup == false)
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                backNavigationBar(
                    context: context,
                    title: LocalizationString.setProfileCategoryType)
              ],
            ),
          if (widget.isFromSignup == true)
            Text(LocalizationString.setProfileCategoryType,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.setProfileCategoryTypeSubHeading,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.separated(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 100, left: 16, right: 16),
                  itemCount: 10,
                  itemBuilder: (ctx, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'type',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Obx(() => ThemeIconWidget(_setProfileCategoryController
                                    .profileCategoryType.value ==
                                index
                            ? ThemeIcon.checkMarkWithCircle
                            : ThemeIcon.circleOutline)),
                      ],
                    ).ripple(() {
                      _setProfileCategoryController
                          .setProfileCategoryType(index);
                    });
                  },
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(height: 20);
                  })),
          FilledButtonType1(
              text: LocalizationString.submit,
              onPress: () {
                profileController.updateProfileCategoryType(
                    profileCategoryType: 1,
                    isSigningUp: true,
                    context: context);
              }).hP16,
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
