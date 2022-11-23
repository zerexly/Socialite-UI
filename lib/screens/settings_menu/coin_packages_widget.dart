import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CoinPackagesWidget extends StatefulWidget {
  const CoinPackagesWidget({Key? key}) : super(key: key);

  @override
  State<CoinPackagesWidget> createState() => _CoinPackagesWidgetState();
}

class _CoinPackagesWidgetState extends State<CoinPackagesWidget> {
  final SubscriptionPackageController packageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: GetBuilder<SubscriptionPackageController>(
          init: packageController,
          builder: (ctx) {
            return ListView.separated(
                padding: const EdgeInsets.only(top: 20,bottom: 70),
                itemBuilder: (ctx, index) {
                  return PackageTile(
                    package: packageController.packages[index],
                    index: index,
                    buyPackageHandler: () {
                      buyPackage(packageController.packages[index]);
                    },
                  );
                },
                separatorBuilder: (ctx, index) {
                  return divider(context: context).vP16;
                },
                itemCount: packageController.packages.length);
          }).hP16,
    );
  }

  buyPackage(PackageModel package) {
    if (AppConfigConstants.isDemoApp) {
      AppUtil.showDemoAppConfirmationAlert(
          title: 'Demo app',
          subTitle:
              'This is demo app so you can not make payment to test it, but still you will get some coins',
          cxt: context,
          okHandler: () {
            packageController.subscribeToDummyPackage(context, randomId());
          });
      return;
    }
    if (packageController.isAvailable.value) {
      // packageController.selectedPackage.value = index;
      // For Real Time
      packageController.selectedPurchaseId.value = Platform.isIOS
          ? package.inAppPurchaseIdIOS
          : package.inAppPurchaseIdAndroid;
      List<ProductDetails> matchedProductArr = packageController.products
          .where((element) =>
              element.id == packageController.selectedPurchaseId.value)
          .toList();
      if (matchedProductArr.isNotEmpty) {
        ProductDetails matchedProduct = matchedProductArr.first;
        PurchaseParam purchaseParam = PurchaseParam(
            productDetails: matchedProduct, applicationUserName: null);
        packageController.inAppPurchase.buyConsumable(
            purchaseParam: purchaseParam,
            autoConsume: packageController.kAutoConsume || Platform.isIOS);
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noProductAvailable,
            isSuccess: false);
      }
    } else {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.storeIsNotAvailable,
          isSuccess: false);
    }
  }
}
