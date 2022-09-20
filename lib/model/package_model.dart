class PackageModel {
  int id = 0;
  String name = '';
  int price = 0;
  int coin = 0;

  String inAppPurchaseIdIOS = '';
  String inAppPurchaseIdAndroid = '';

  PackageModel();

  factory PackageModel.fromJson(dynamic json) {
    PackageModel model = PackageModel();
    model.id = json['id'];
    model.name = json['name'];
    model.price = json['price'];
    model.coin = json['coin'];

    model.inAppPurchaseIdIOS = json['in_app_purchase_id_ios'];
    model.inAppPurchaseIdAndroid = json['in_app_purchase_id_android'];

    return model;
  }
}
