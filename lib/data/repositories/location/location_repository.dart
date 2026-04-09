import 'package:flutter/material.dart';
import '/model/ride/locations.dart';

abstract class LocationRepository {
  List<Location> getAllLocations();
  Future<Location> getLocationByName(String name);
}
