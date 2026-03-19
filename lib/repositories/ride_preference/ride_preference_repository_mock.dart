import 'package:blabla/data/dummy_data.dart';
import 'package:blabla/model/ride_pref/ride_pref.dart';
import 'package:blabla/repositories/ride_preference/ride_preference_repository.dart';

class MockRidePreferenceRepository implements RidePreferenceRepository {
  @override
  List<RidePreference> getHistory() {
    return fakeRidePrefs;
  }
}
