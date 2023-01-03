import 'package:intl/intl.dart';
import '../helper/enum.dart';

class EventModel {
  int id;
  String name;
  int categoryId;
  String image;
  int startDate;
  int endDate;
  String placeName;
  String completeAddress;
  String latitude;
  String longitude;
  String disclaimer;
  String description;

  int createdAt;
  int status;
  int eventCurrentStatus;

  int createdBy;
  int? updatedAt;
  int? updatedBy;
  bool isFree;
  List<String> gallery;

  // String desc;
  bool isJoined;
  int totalMembers;
  bool isFavourite;
  bool isTicketBooked;

  List<EventOrganizer> organizers;
  List<EventTicketType> tickets;

  EventModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.placeName,
    required this.completeAddress,
    required this.latitude,
    required this.longitude,
    required this.disclaimer,
    required this.description,
    required this.createdAt,
    required this.status,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.gallery,
    required this.isFree,
    // required this.desc,
    required this.isJoined,
    // required this.imageName,
    required this.totalMembers,
    required this.isFavourite,
    required this.tickets,
    required this.organizers,
    required this.eventCurrentStatus,
    required this.isTicketBooked,

    // required this.address,
    // required this.sponsorImage,
    // required this.sponsorName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        name: json["name"],
        categoryId: json["category_id"],
        image: json["imageUrl"],
        // imageName: json["image"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        placeName: json["place_name"],
        completeAddress: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        disclaimer: json["disclaimer"],
        description: json["description"],
        status: json["status"],
        eventCurrentStatus: json["eventCurrentStatus"],

        isFree: json["is_paid"] == 0,
        isTicketBooked: json["is_ticket_booked"] == 1,

        createdAt: json["created_at"],
        createdBy: json["created_by"],
        updatedAt: json["updated_at"],
        updatedBy: json["updated_by"],
        gallery: json["eventGallaryImages"] == null
            ? []
            : (json["eventGallaryImages"] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
        organizers: json["eventOrganisor"] != null
            ? [EventOrganizer.fromJson(json["eventOrganisor"])]
            : [],
        // organizers: json["eventOrganisor"] == null
        //     ? []
        //     : (json["eventOrganisor"] as List<dynamic>)
        //         .map((e) => EventOrganisor.fromJson(e))
        //         .toList(),
        tickets: json["eventTicket"] == null
            ? []
            : (json["eventTicket"] as List<dynamic>)
                .map((e) => EventTicketType.fromJson(e))
                .toList(),
        isFavourite: json["isFavourite"] == 1,
        totalMembers: json["totalMembers"] ?? 0,
        isJoined: json["isJoined"] == 1,
      );

  EventStatus get statusType {
    switch (eventCurrentStatus) {
      case 1:
        return EventStatus.upcoming;
      case 2:
        return EventStatus.active;
      case 3:
        return EventStatus.completed;
    }
    return EventStatus.upcoming;
  }

  bool get ticketsAdded {
    List<EventTicketType> ticketTypes =
        tickets.where((element) => element.availableTicket > 0).toList();
    return ticketTypes.isNotEmpty;
  }

  bool get isSoldOut {
    List<EventTicketType> ticketTypes =
        tickets.where((element) => element.availableTicket > 0).toList();
    return ticketTypes.isEmpty;
  }

  String get startAtDate {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(startDate * 1000);

    return DateFormat('dd-MMM-yyyy').format(callStartTime);
  }

  String get endAtDate {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(endDate * 1000);

    return DateFormat('dd-MMM-yyyy').format(callStartTime);
  }

  String get startAtFullDate {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(startDate * 1000);

    return DateFormat('EEE, dd-MMM-yyyy').format(callStartTime);
  }

  String get endAtFullDate {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(endDate * 1000);

    return DateFormat('dd-MMM-yyyy').format(callStartTime);
  }

  String get startAtDateTime {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(startDate * 1000);

    return DateFormat('dd-MM-yyyy hh:mm a').format(callStartTime);
  }

  String get endAtDateTime {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(endDate * 1000);

    return DateFormat('dd-MM-yyyy hh:mm a').format(callStartTime);
  }

  String get startAtTime {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(startDate * 1000);

    return DateFormat('hh:mm a').format(callStartTime);
  }

  String get endAtTime {
    DateTime callStartTime =
        DateTime.fromMillisecondsSinceEpoch(endDate * 1000);

    return DateFormat('hh:mm a').format(callStartTime);
  }
}

class EventTicketType {
  int id;
  int eventId;
  String name;
  double price;
  int limit;
  int availableTicket;
  int status;

  EventTicketType({
    required this.id,
    required this.eventId,
    required this.name,
    required this.price,
    required this.limit,
    required this.availableTicket,
    required this.status,
  });

  factory EventTicketType.fromJson(Map<String, dynamic> json) =>
      EventTicketType(
        id: json["id"],
        eventId: json["event_id"],
        name: json["ticket_type"],
        price: double.parse(json["price"].toString()),
        limit: json["limit"],
        availableTicket: json["available_ticket"],
        status: json["status"],
      );
}

class EventOrganizer {
  int id;
  String name;
  String image;

  EventOrganizer({
    required this.id,
    required this.name,
    required this.image,
  });

  factory EventOrganizer.fromJson(Map<String, dynamic> json) => EventOrganizer(
        id: json["id"],
        name: json["name"],
        image: json["imageUrl"],
      );
}

class EventCoupon {
  int id;
  String title;
  String subTitle;

  String code;
  double minimumOrderPrice;
  String image;
  double discount;

  EventCoupon({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.code,
    required this.minimumOrderPrice,
    required this.image,
    required this.discount,
  });

  factory EventCoupon.fromJson(Map<String, dynamic> json) => EventCoupon(
        id: json["id"],
        title: json["title"],
        subTitle: json["subtitle"],
        code: json["code"],
        minimumOrderPrice: double.parse(json["minimum_order_price"].toString()),
        image: json["imageUrl"],
        discount: double.parse(json["coupon_value"].toString()),
      );
}

class EventTicketOrderRequest {
  int? eventId;
  int? eventTicketTypeId;
  int? qty;

  String? coupon;
  double? discount;
  double? ticketAmount;
  double? paidAmount;
  double? amountToBePaid;
  String? itemName;

  List<Map<String, dynamic>> payments;

  EventTicketOrderRequest({
    this.eventId,
    this.eventTicketTypeId,
    this.qty,
    this.coupon,
    this.discount,
    this.ticketAmount,
    this.paidAmount,
    this.itemName,
    required this.payments,
  });

  Map<String, dynamic> toJson() => {
        "event_id": eventId.toString(),
        "event_ticket_id": eventTicketTypeId.toString(),
        "ticket_qty": qty.toString(),
        "coupon": coupon,
        "coupon_discount_value":
            discount == null || discount == 0 ? 0 : discount,
        "ticket_amount": ticketAmount.toString(),
        "paid_amount": paidAmount.toString(),
        "payments": payments,
      };
}
