import 'package:blabla/model/ride/locations.dart';

abstract class LocationRepository {
  List<Location> getLocations();
  Location getLocationByName(String name);
}
