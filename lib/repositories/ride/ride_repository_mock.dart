import 'package:blabla/data/dummy_data.dart';
import 'package:blabla/model/ride/ride.dart';
import 'package:blabla/repositories/ride/ride_repository.dart';

class MockRideRepository implements RideRepository {
  @override
  List<Ride> getRides() {
    return fakeRides;
  }
}
