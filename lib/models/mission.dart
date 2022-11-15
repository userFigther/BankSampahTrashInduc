class Mission {
  String? id;
  String? name;
  int? balance;
  int? exp;
  // ignore: non_constant_identifier_names
  bool? is_active;
  bool? hidden;

  Mission({
    this.id,
    this.name,
    this.balance,
    this.exp,
    // ignore: non_constant_identifier_names
    this.is_active,
    this.hidden,
  });

  Mission.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"]! as String,
            name: json["name"]! as String,
            balance: json["balance"]! as int,
            exp: json["exp"] as int,
            is_active: json["is_active"] as bool,
            hidden: json["hidden"] as bool);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "balance": balance,
      "exp": exp,
      "is_active": is_active,
      "hidden": hidden
    };
  }
}
