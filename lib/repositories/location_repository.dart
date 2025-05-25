import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';

abstract class LocationRepository extends ChangeNotifier {
  Future<void> add(Location location);
  Future<void> remove(int id);
  Future<void> update(Location location);
  Future<Location> getById(int id);
  Future<List<Location>> getAll({required int userId, String? filter});
}
