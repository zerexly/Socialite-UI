import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class BuyTicketController extends GetxController {
  RxInt numberOfTickets = 1.obs;

  addTicket() {
    numberOfTickets.value += 1;
  }

  removeTicket() {
    if (numberOfTickets.value > 1) {
      numberOfTickets.value -= 1;
    }
  }
}
