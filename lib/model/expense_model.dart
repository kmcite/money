class Expense {
  Expense({
    this.id = '',
    this.money = 0,
    this.note = '',
    DateTime? date,
    this.schemaVersion = 1,
  }) : date = date ?? DateTime.now();

  final String id;
  final int money;
  final String note;
  final DateTime date;
  final int schemaVersion;

  bool get isPersisted => id.isNotEmpty;

  Expense copyWith({
    String? id,
    int? money,
    String? note,
    DateTime? date,
    int? schemaVersion,
  }) {
    return Expense(
      id: id ?? this.id,
      money: money ?? this.money,
      note: note ?? this.note,
      date: date ?? this.date,
      schemaVersion: schemaVersion ?? this.schemaVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'money': money,
      'note': note,
      'date': date.toIso8601String(),
      'schemaVersion': schemaVersion,
    };
  }

  factory Expense.fromJson(String id, Map<String, dynamic> json) {
    final rawDate = json['date'];
    final date = switch (rawDate) {
      String() => DateTime.tryParse(rawDate) ?? DateTime.now(),
      num() => DateTime.fromMillisecondsSinceEpoch(rawDate.toInt()),
      _ => DateTime.now(),
    };

    return Expense(
      id: id,
      money: (json['money'] as num?)?.toInt() ?? 0,
      note: json['note'] as String? ?? '',
      date: date,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );
  }
}

extension ExpenseDateExtension on Expense {
  int get day => date.day;
  int get month => date.month;
  int get year => date.year;
}
