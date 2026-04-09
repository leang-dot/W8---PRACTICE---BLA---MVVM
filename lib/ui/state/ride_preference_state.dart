
import 'package:blabla/model/ride_pref/ride_pref.dart';
import 'package:flutter/material.dart';
import '/data/repositories/ride_preference/ride_preference_repository_mock.dart';
import 'package/model/ride_pref/ride_pref.dart';

class RidePreferenceState extends ChangeNotifier {
  final RidePreferenceRepositoryMock repository;

  RidePreference? _selectedRidePreference;
  List<RidePreference> _rideHistory = [];

  RidePreferenceState({required this.repository}) {
    _selectedRidePreference = repository.currentPreference;
    _rideHistory = repository.getHistory();
  }

  RidePreference? get selectedRidePreference {
    return _selectedRidePreference;
  }

  List<RidePreference> get rideHistory {
    return _rideHistory;
  }

  void setRidePreference(RidePreference newPreference) {
    repository.setPreference(newPreference);
    _selectedRidePreference = repository.currentPreference;
    notifyListeners();
  }
}
