import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';
import 'package:flutter_agenda_app/repositories/location_repository.dart';

class LocationRepositoryMemory extends ChangeNotifier
    implements LocationRepository {
  final List<Location> _locations = [];

  @override
  List<Location> get locations => UnmodifiableListView(_locations);

  @override
  Future<void> add(Location location) async {
    final newLocation = Location(
      id: Random().nextInt(10000),
      zipCode: location.zipCode,
      address: location.address,
      noNumber: location.noNumber,
      number: location.number,
      city: location.city,
      state: location.state,
      neighborhood: location.neighborhood,
    );

    _locations.add(newLocation);
    notifyListeners();
  }

  @override
  Future<List<Location>> getAll(String? filter) async {
    if (filter == null || filter.isEmpty) {
      return _locations;
    }

    return _locations.where((location) {
      return location.address.toLowerCase().contains(filter.toLowerCase());
    }).toList();
  }

  @override
  Future<Location> getById(int id) async {
    return _locations.firstWhere((location) => location.id == id);
  }

  @override
  Future<void> remove(int id) async {
    _locations.removeWhere((location) => location.id == id);
    notifyListeners();
  }

  @override
  Future<void> update(Location appointment) async {
    final index = _locations.indexWhere(
      (location) => location.id == appointment.id,
    );
    if (index != -1) {
      _locations[index] = appointment;
      notifyListeners();
    }
  }
}
