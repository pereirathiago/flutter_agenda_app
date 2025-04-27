import 'package:flutter/material.dart';
import 'package:flutter_agenda_app/models/location.dart';

abstract class LocationRepository extends ChangeNotifier {
  List<Location> get locations;

  void add(Location location);
  void remove(int id);
  void update(Location appointment);
  Location getById(int id);
  List<Location> getAll(String? filter);
}
