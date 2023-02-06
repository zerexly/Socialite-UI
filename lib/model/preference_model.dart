import '../util/shared_prefs.dart';

class AddPreferenceModel {
  String? city;
  String? country;
  String? name;
}

class AddPreferenceManager {
  AddPreferenceModel? preference;

  AddPreferenceModel? get preferenceModel {
    return preference;
  }
}
