abstract class LocationRepository {
  Future<void> insertLocation(String type, String value);
  Future<List<String>> getLocationValues(String type);
}
