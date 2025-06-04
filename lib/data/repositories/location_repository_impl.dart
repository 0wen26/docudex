import '../../database/database_helper.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final DatabaseHelper databaseHelper;

  LocationRepositoryImpl({required this.databaseHelper});

  @override
  Future<void> insertLocation(String type, String value) {
    return databaseHelper.insertLocation(type, value);
  }

  @override
  Future<List<String>> getLocationValues(String type) {
    return databaseHelper.getLocationValues(type);
  }
}
