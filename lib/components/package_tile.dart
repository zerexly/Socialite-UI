import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PackageTile extends StatelessWidget {
  final PackageModel package;
  final int index;
  final SubscriptionPackageController packageController = Get.find();
  final VoidCallback buyPackageHandler;

  PackageTile(
      {Key? key,
      required this.package,
      required this.index,
      required this.buyPackageHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${package.coin} ${LocalizationString.coins}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const Spacer(),
        Text(
          '${LocalizationString.buyIn} \$${package.price}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w700),
        )
        // SizedBox(
        //   height: 40,
        //   width: 110,
        //   child: BorderButtonType1(
        //     text:,
        //     onPress: () {
        //
        //     },
        //   ),
        // )
      ],
    ).ripple(() {
      buyPackageHandler();
    });
  }
}
