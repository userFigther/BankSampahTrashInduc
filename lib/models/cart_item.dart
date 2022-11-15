import 'package:trash_induc/models/item.dart';

class CartItem {
  Item item;
  String type;
  double qty;
  double price;

  CartItem(
    this.item,
    this.type,
    this.qty,
    this.price,
  );

  double getTotalPrice() {
    if (qty > 0 && price > 0) {
      return qty * price;
    }

    return 0;
  }
}
