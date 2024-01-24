import 'package:drift/drift.dart';

@DataClassName('Car')
class Cars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().nullable()();
  TextColumn get model => text().nullable()();
  IntColumn get year => integer().nullable()();
}
