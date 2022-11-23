import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RequestVerificationList extends StatefulWidget {
  final List<VerificationRequest> requests;

  const RequestVerificationList({Key? key, required this.requests})
      : super(key: key);

  @override
  State<RequestVerificationList> createState() =>
      _RequestVerificationListState();
}

class _RequestVerificationListState extends State<RequestVerificationList> {
  final RequestVerificationController _requestVerificationController =
      Get.find();

  @override
  void initState() {
    super.initState();
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
            backNavigationBar(
                context: context,
                title: LocalizationString.requestVerification),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<RequestVerificationController>(
                  init: _requestVerificationController,
                  builder: (ctx) {
                    return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _requestVerificationController
                            .verificationRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          VerificationRequest request =
                              _requestVerificationController
                                  .verificationRequests[index];
                          return Container(
                            height: 80,
                            width: 80,
                            color: Theme.of(context).cardColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          ThemeIconWidget(
                                            ThemeIcon.calendar,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 15,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            request.sentOn,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${LocalizationString.status} :',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w800),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            request.isProcessing
                                                ? LocalizationString
                                                    .inProcessing
                                                : request.isCancelled
                                                    ? LocalizationString
                                                        .cancelled
                                                    : request.isRejected
                                                        ? LocalizationString
                                                            .rejected
                                                        : LocalizationString
                                                            .approved,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: request.isProcessing
                                                        ? Colors.yellow
                                                        : request.isRejected ||
                                                                request
                                                                    .isCancelled
                                                            ? Colors.red
                                                            : Colors.green),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                if (request.isProcessing)
                                  Container(
                                    width: 80,
                                    color: Theme.of(context).primaryColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const ThemeIconWidget(ThemeIcon.close,
                                            size: 28),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          LocalizationString.cancel,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        )
                                      ],
                                    ),
                                  ).ripple(() {
                                    _requestVerificationController
                                        .cancelRequest(request.id);
                                  }),
                                if (request.isRejected)
                                  const ThemeIconWidget(
                                    ThemeIcon.nextArrow,
                                    size: 18,
                                  ).rP16
                              ],
                            ).lP16,
                          ).ripple(() {
                            if (request.isRejected) {
                              Get.to(() => const VerificationRejectReason());
                            }
                          });
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return divider(context: context).vP8;
                        });
                  }),
            ),
          ],
        ));
  }
}
