import 'package:foap/model/user_model.dart';

class AddPreferenceModel {
  int? gender;
  int? ageFrom;
  int? ageTo;
  int? heightFrom;
  int? heightTo;
  String? selectedColor;
  String? religion;
  int? status;

  int? smoke;
  int? drink;

  List<InterestModel>? interests;
  List<LanguageModel>? languages;

  AddPreferenceModel();

  factory AddPreferenceModel.fromJson(dynamic json) {
    AddPreferenceModel model = AddPreferenceModel();
    model.gender = json["gander"];
    model.ageFrom = json["age_from"];
    model.ageTo = json["age_to"];
    // model.heightFrom = json[""];
    model.heightTo = json["height"] == null
        ? null
        : json["height"] is String
            ? int.parse(json["height"])
            : json["height"];
    model.selectedColor = json["color"];
    model.religion = json["religion"];
    model.status = json["marital_status"];
    model.smoke = json["smoke_id"];
    model.drink = json["drinking_habit"] == null
        ? null
        : json["drinking_habit"] is String
            ? int.parse(json["drinking_habit"])
            : json["drinking_habit"];

    if (json['preferenceInterest'] != null &&
        json['preferenceInterest'].length > 0) {
      model.interests = List<InterestModel>.from(
          json['preferenceInterest'].map((x) => InterestModel.fromJson(x)));
    }

    if (json['preferenceLanguage'] != null &&
        json['preferenceLanguage'].length > 0) {
      model.languages = List<LanguageModel>.from(
          json['preferenceLanguage'].map((x) => LanguageModel.fromJson(x)));
    }
    return model;
  }
}

class AddDatingDataModel {
  String? latitude;
  String? longitude;
  String? name;
  String? dob;
  int? gender;
  String? selectedColor;
  int? height;
  String? religion;
  int? status;
  int? smoke;
  int? drink;
  List<InterestModel>? interests;
  List<LanguageModel>? languages;
  String? qualification;
  String? occupation;
  String? experienceMonth;
  String? experienceYear;

  AddDatingDataModel();
}