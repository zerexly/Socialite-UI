import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChangeLocation extends StatefulWidget {
  const ChangeLocation({Key? key}) : super(key: key);

  @override
  State<ChangeLocation> createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();

  late UserModel model;

  final ProfileController profileController = Get.find();

  @override
  void initState() {
    model = getIt<UserProfileManager>().user!;

    super.initState();

    country.text = model.country ?? '' ;
    city.text = model.city ?? '' ;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          profileScreensNavigationBar(
              context: context,
              title: LocalizationString.changeLocation,
              completion: () {
                updateLocation();
              }),
          divider(context: context).vP8,
          const SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocalizationString.country,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
              Container(
                color: Colors.transparent,
                height: 50,
                child: InputField(
                  controller: country,
                  showDivider: true,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  hintText: LocalizationString.country,
                ),
              ).vP8,
              const SizedBox(
                height: 20,
              ),
              Text(LocalizationString.city,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
              Container(
                color: Colors.transparent,
                height: 50,
                child: InputField(
                  controller: city,
                  showDivider: true,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  hintText: LocalizationString.city,
                ),
              ).vP8,
              const SizedBox(
                height: 20,
              ),
            ],
          ).hP16,
        ],
      ),
    );
  }

  updateLocation() {
    profileController.updateLocation(country: country.text, city: city.text,context: context);
  }
}
