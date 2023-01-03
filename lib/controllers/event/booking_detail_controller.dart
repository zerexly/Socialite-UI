import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class EventBookingDetailController extends GetxController {
  Rx<EventBookingModel?> eventBooking = Rx<EventBookingModel?>(null);
  RxList<EventCoupon> coupons = <EventCoupon>[].obs;
  double? minTicketPrice;
  double? maxTicketPrice;

  RxBool bookingCancelled = false.obs;

  setEventBooking(EventBookingModel eventBooking) {
    this.eventBooking.value = eventBooking;
    this.eventBooking.refresh();
    update();
  }

  saveETicket(Uint8List bytes, BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final pathOfImage = await File('${directory.path}/ticket.png').create();
    await pathOfImage.writeAsBytes(bytes);

    Share.shareXFiles([XFile(pathOfImage.path)]).then((result) {
      if (result.status == ShareResultStatus.success) {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.ticketSaved,
            isSuccess: true);
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.errorMessage,
            isSuccess: false);
      }
    });
  }

  cancelBooking(BuildContext context) {
    EasyLoading.show(status: LocalizationString.loading);
    ApiController()
        .cancelEventBooking(bookingId: eventBooking.value!.id)
        .then((result) {
      EasyLoading.dismiss();
      if (result.success) {
        // AppUtil.showToast(
        //     context: context,
        //     message: LocalizationString.bookingCancelled,
        //     isSuccess: true);
        bookingCancelled.value = true;
        update();
      } else {
        AppUtil.showToast(
            context: context, message: result.message, isSuccess: false);
      }
    });
  }
}
