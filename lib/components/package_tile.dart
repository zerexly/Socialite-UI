import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PackageTile extends StatelessWidget {
  final PackageModel package;
  final int index;
  final SubscriptionPackageController packageController = Get.find();

  PackageTile({Key? key, required this.package, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${package.coin} ${LocalizationString.coins}',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        SizedBox(
          height: 35,
          width: 110,
          child: BorderButtonType1(
            text: '${LocalizationString.buyIn} \$${package.price}',
            onPress: () {
              if (packageController.isAvailable.value) {
                packageController.selectedPackage.value = index;
                // For Real Time
                packageController.selectedPurchaseId.value = Platform.isIOS
                    ? package.inAppPurchaseIdIOS
                    : package.inAppPurchaseIdAndroid;
                List<ProductDetails> matchedProductArr = packageController
                    .products
                    .where((element) =>
                element.id ==
                    packageController.selectedPurchaseId.value)
                    .toList();
                if (matchedProductArr.isNotEmpty) {
                  ProductDetails matchedProduct = matchedProductArr.first;
                  PurchaseParam purchaseParam = PurchaseParam(
                      productDetails: matchedProduct,
                      applicationUserName: null);
                  packageController.inAppPurchase.buyConsumable(
                      purchaseParam: purchaseParam,
                      autoConsume:
                      packageController.kAutoConsume || Platform.isIOS);
                } else {
                  AppUtil.showToast(context: context,
                      message: LocalizationString.noProductAvailable,
                      isSuccess: false);
                }
              } else {
                AppUtil.showToast(context: context,
                    message: LocalizationString.storeIsNotAvailable,
                    isSuccess: false);
              }
            },
          ),
        )
      ],
    );
  }
}
