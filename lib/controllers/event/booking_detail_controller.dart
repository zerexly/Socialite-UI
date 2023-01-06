import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

enum ProcessingBookingStatus { inProcess, gifted, cancelled, failed }

class EventBookingDetailController extends GetxController {
  Rx<EventBookingModel?> eventBooking = Rx<EventBookingModel?>(null);
  RxList<EventCoupon> coupons = <EventCoupon>[].obs;
  double? minTicketPrice;
  double? maxTicketPrice;

  Rx<ProcessingBookingStatus?> processingBooking =
      Rx<ProcessingBookingStatus?>(null);

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

  giftToUser(UserModel user) {
    processingBooking.value = ProcessingBookingStatus.inProcess;
    update();
    ApiController()
        .giftEventTicket(ticketId: eventBooking.value!.id, toUserId: user.id)
        .then((response) {
      if (response.success) {
        processingBooking.value = ProcessingBookingStatus.gifted;
      } else {
        processingBooking.value = ProcessingBookingStatus.failed;
      }
      update();
    });
  }

  cancelBooking(BuildContext context) {
    processingBooking.value = ProcessingBookingStatus.inProcess;
    update();
    ApiController()
        .cancelEventBooking(bookingId: eventBooking.value!.id)
        .then((result) {
      EasyLoading.dismiss();
      if (result.success) {
        processingBooking.value = ProcessingBookingStatus.cancelled;
      } else {
        processingBooking.value = ProcessingBookingStatus.failed;
      }
      update();
    });
  }
}
