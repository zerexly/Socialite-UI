import 'package:foap/helper/common_import.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class WebViewScreen extends StatefulWidget {
  final String header;
  final String url;
  const WebViewScreen({Key? key,required this.header, required this.url}): super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewScreen> {
  late final String header;
  late final String url;

  @override
  void initState() {
    super.initState();
    header = widget.header;
    url = widget.url;
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            elevation: 0.0,
            title: Text(
              header,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
            leading: InkWell(
                onTap: () => Get.back(),
                child:
                    const Icon(Icons.arrow_back_ios_rounded, color: Colors.white))),
        body: WebView(
          initialUrl: url,
        ));
  }
}
