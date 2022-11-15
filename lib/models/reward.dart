import 'package:cloud_firestore/cloud_firestore.dart';

class Reward {
  String? id;
  String? name;
  int? cost;
  // ignore: non_constant_identifier_names
  Timestamp? expired_at;
  Timestamp? created_at;
  String? photoUrl;

  Reward({
    this.id,
    this.name,
    this.cost,
    // ignore: non_constant_identifier_names
    this.expired_at,
    this.created_at,
    this.photoUrl,
  });

  Reward.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"] as String,
          name: json["name"]! as String,
          cost: json["cost"]! as int,
          expired_at: json["expired_at"]! as Timestamp,
          created_at: json["created_at"]! as Timestamp,
          photoUrl: json["photoUrl"]! as String,
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "cost": cost,
      "expired_at": expired_at,
      "created_at": created_at,
      "photoUrl": photoUrl,
    };
  }
}
