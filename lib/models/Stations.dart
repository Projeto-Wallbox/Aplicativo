import 'package:drift/drift.dart';

@DataClassName('Station')
class Stations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get user => text()();
  TextColumn get password => text()();
  TextColumn get ipAddress => text()();
}
