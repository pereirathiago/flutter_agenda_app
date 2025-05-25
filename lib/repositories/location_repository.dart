import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';

abstract class LocationRepository extends ChangeNotifier {
  List<Location> get locations;

  Future<void> add(Location location);
  Future<void> remove(int id);
  Future<void> update(Location appointment);
  Future<Location> getById(int id);
  Future<List<Location>> getAll(String? filter);
}
