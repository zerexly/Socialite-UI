import 'package:foap/helper/common_import.dart';
import 'package:intl/intl.dart';

class EventBookingModel {
  int id;
  int eventId;
  int eventTicketId;
  int userId;
  int qty;
  String? coupon;
  double discount;
  double ticketAmount;
  double paidAmount;
  int createdAt;
  int status;
  EventTicketType ticketType;
  EventModel event;
  String? ticketUrl;

  UserModel? giftedToUser;
  UserModel? giftedByUser;

  EventBookingModel({
    required this.id,
    required this.eventId,
    required this.eventTicketId,
    required this.userId,
    required this.qty,
    required this.coupon,
    required this.discount,
    required this.paidAmount,
    required this.ticketAmount,
    required this.createdAt,
    required this.status,
    required this.ticketType,
    required this.event,
    required this.ticketUrl,
    this.giftedByUser,
    this.giftedToUser,
  });

  factory EventBookingModel.fromJson(Map<String, dynamic> json) =>
      EventBookingModel(
        id: json["id"],
        eventId: json["event_id"],
        eventTicketId: json["event_ticket_id"],
        userId: json["user_id"],
        qty: json["ticket_qty"],
        coupon: json["coupon"],
        discount: double.parse(json["coupon_discount_value"].toString()),
        ticketAmount: double.parse(json["ticket_amount"].toString()),
        paidAmount: double.parse(json["paid_amount"].toString()),
        createdAt: json["created_at"],
        status: json["status"],
        ticketType: EventTicketType.fromJson(json["ticketDetail"]),
        event: EventModel.fromJson(json["event"]),
        ticketUrl: json["viewTicketUrl"],
        giftedByUser: json["giftedByUser"] == null
            ? null
            : UserModel.fromJson(json["giftedByUser"]),
        giftedToUser: json["giftedToUser"] == null
            ? null
            : UserModel.fromJson(json["giftedToUser"]),
      );

  BookingStatus get statusType {
    switch (event.isTicketBooked) {
      case true:
        return BookingStatus.confirmed;
      case false:
        return BookingStatus.cancelled;
    }
    return BookingStatus.confirmed;
  }

  String get bookingDatetime {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

    return DateFormat('dd-MMM-yyyy hh:mm a').format(callStartTime);
  }
}
