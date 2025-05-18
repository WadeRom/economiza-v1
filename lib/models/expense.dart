class Expense {
  final int? id;
  final String description;
  final String category;
  final double amount;
  final String date;

  Expense({
    this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'category': category,
      'amount': amount,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      description: map['description'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
