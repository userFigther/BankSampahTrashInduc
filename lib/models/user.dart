class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  double? exp;
  double? balance;
  String? photoUrl;
  String? postalCode;
  String role;
  String membership;

  User({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.address = "",
    this.exp = 0,
    this.balance = 0,
    this.photoUrl = "",
    this.postalCode = "",
    this.role = "user",
    this.membership = "bronze",
  });

  User.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"]! as String,
          name: json["name"]! as String,
          email: json["email"]! as String,
          phone: json["phone"]! as String,
          address: json["address"]! as String,
          exp: double.tryParse(json['exp'].toString()),
          balance: double.tryParse(json['balance'].toString()),
          photoUrl: json["photoUrl"]! as String,
          postalCode: json["postalCode"]! as String,
          role: json["role"]! as String,
          membership: json["membership"]! as String,
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "exp": exp,
      "balance": balance,
      "photoUrl": photoUrl,
      "postalCode": postalCode,
      "role": role,
      "membership": membership
    };
  }
}
