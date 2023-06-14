import '../database.dart';

class DemoTable extends SupabaseTable<DemoRow> {
  @override
  String get tableName => 'demo';

  @override
  DemoRow createRow(Map<String, dynamic> data) => DemoRow(data);
}

class DemoRow extends SupabaseDataRow {
  DemoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DemoTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
