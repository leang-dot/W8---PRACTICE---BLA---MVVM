import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/repositories/ride/ride_repository_mock.dart';
import '/data/repositories/location/location_repository_mock.dart';
import '/data/repositories/ride_preference/ride_preference_repository_mock.dart';
import '/ui/state/ride_preference_state.dart';
import 'main_common.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => RideRepositoryMock()),
        Provider(create: (_) => LocationRepositoryMock()),
        ChangeNotifierProvider(
          create: (_) {
            return RidePreferenceState(
              repository: RidePreferenceRepositoryMock(),
            );
          },
        ),
      ],
      child: const BlaBlaApp(),
    ),
  );
}
