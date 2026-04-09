import '/data/dummy_data.dart';
import '/data/repositories/ride/ride_repository.dart';
import '/model/ride/locations.dart';
import '/model/ride/ride.dart';

class RideRepositoryMock implements RideRepository {
  List<Ride> rides = [];

  @override
  Future<List<Ride>> getAllRides() async {
    rides = fakeRides;
    return rides;
  }

  @override
  Future<Location> getDepartureLocation(Location location) async {
    List<Ride> rides = await getAllRides();
    final ride = rides.firstWhere(
      (ride) => ride.departureLocation.name == location.name,
    );

    return ride.departureLocation;
  }

  @override
  Future<Location> getArriveLocation(Location location) async {
    List<Ride> rides = await getAllRides();
    final ride = rides.firstWhere(
      (ride) => ride.arrivalLocation.name == location.name,
      orElse: () =>
          throw Exception('No ride found for location: ${location.name}'),
    );

    return ride.arrivalLocation;
  }
}
