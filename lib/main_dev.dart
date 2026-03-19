import 'package:blabla/repositories/location/location_repository_mock.dart';
import 'package:blabla/repositories/ride/ride_repository_mock.dart';
import 'package:blabla/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_common.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => MockRideRepository()),
        Provider(create: (_) => MockLocationRepository()),
        Provider(create: (_) => MockRidePreferenceRepository()),
      ],
      child: const BlaBlaApp(),
    ),
  );
}
