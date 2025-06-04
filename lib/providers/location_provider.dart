import 'package:flutter/material.dart';

import '../domain/repositories/location_repository.dart';
import '../injection_container.dart';

class LocationProvider extends ChangeNotifier {
  final LocationRepository _repository = getIt<LocationRepository>();

  final Map<String, List<String>> _data = {
    'room': [],
    'area': [],
    'box': [],
  };

  LocationProvider() {
    _load('room');
    _load('area');
    _load('box');
  }

  List<String> getByType(String type) => _data[type] ?? [];

  Future<void> reload(String type) => _load(type);

  Future<void> _load(String type) async {
    _data[type] = await _repository.getLocationValues(type);
    notifyListeners();
  }

  Future<void> add(String type, String value) async {
    await _repository.insertLocation(type, value);
    await _load(type);
  }
}
