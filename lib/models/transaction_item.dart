import 'package:trash_induc/models/item.dart';

class TransactionItem {
  String? transaction_id;
  Item? item;
  double? qty;

  TransactionItem({
    this.transaction_id,
    this.item,
    this.qty,
  });

  TransactionItem.fromJson(Map<String, dynamic> json)
      : this(
          transaction_id: json["transaction_id"],
          item: Item.fromJson(json["item"]),
          qty: json["qty"],
        );

  Map<String, dynamic> toJson() {
    return {
      "transaction_id": transaction_id,
      "item": item,
      "qty": qty,
    };
  }
}
