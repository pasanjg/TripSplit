import 'data_service.dart';
import 'firebase_service.dart';
import 'localstorage_service.dart';
import 'trip_service.dart';
import 'user_service.dart';
import 'connectivity_service.dart';

class Service {
  Service._();

  static final Service instance = Service._();

  final FirebaseService firebase = FirebaseService.instance;
  final ConnectivityService connectivity = ConnectivityService.instance;

  final DataService data = DataService.instance;
  final UserService user = UserService.instance;
  final TripService trip = TripService.instance;
  final LocalStorageService localStorage = LocalStorageService.instance;
}
