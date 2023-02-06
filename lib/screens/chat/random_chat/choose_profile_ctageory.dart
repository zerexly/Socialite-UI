import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseProfileCategory extends StatefulWidget {
  final bool isCalling;

  const ChooseProfileCategory({Key? key, required this.isCalling})
      : super(key: key);

  @override
  State<ChooseProfileCategory> createState() => _ChooseProfileCategoryState();
}

class _ChooseProfileCategoryState extends State<ChooseProfileCategory> {
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
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(
              context: context, title: LocalizationString.strangerChat),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.setProfileCategoryType,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.weWillSearchUserInCategory,
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
                        const ThemeIconWidget(ThemeIcon.nextArrow)
                      ],
                    ).ripple(() {
                      Get.to(() => FindRandomUser(isCalling: widget.isCalling));
                    });
                  },
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(height: 20);
                  })),
          FilledButtonType1(
              text: LocalizationString.skip,
              onPress: () {
                Get.to(() => FindRandomUser(isCalling: widget.isCalling));
              }).hP16,
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
