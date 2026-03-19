import 'package:blabla/data/dummy_data.dart';
import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/repositories/location/location_repository.dart';

class MockLocationRepository implements LocationRepository {
  @override
  List<Location> getLocations() {
    return fakeLocations;
  }

  @override
  Location getLocationByName(String name) {
    return fakeLocations.firstWhere((loccation) => loccation.name == name);
  }
}
