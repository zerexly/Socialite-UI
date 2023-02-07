import '../helper/pub_import.dart';
import '../util/shared_prefs.dart';

class AddPreferenceModel {
  String? city;
  String? country;
  String? name;
  List<XFile> images = [];
  String? dob;
  int? ageFrom;
  int? ageTo;

  int? gender;
  int? whomToDateGender;

  String? selectedColor;
  int? height;
  int? heightFrom;
  int? heightTo;

  String? religion;
  int? status;

  int? smoke;
  int? drink;
  String? interests;
  String? languages;

  String? qualification;
  String? occupation;
  String? industry;
  String? experience;
}

class AddPreferenceManager {
  AddPreferenceModel? preference;

  AddPreferenceModel? get preferenceModel {
    return preference;
  }
}

class LanguageModel {
  String? name;
  int? id;
  LanguageModel(this.name, this.id);
}