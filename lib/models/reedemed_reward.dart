import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trash_induc/models/reward.dart';
import 'package:trash_induc/models/user.dart';

class RedeemedReward {
  String? id;
  Reward? reward;
  User? user;
  User? petugas;
  String? status;
  Timestamp? created_at;
  Timestamp? updated_at;

  RedeemedReward({
    this.id,
    this.reward,
    this.user,
    this.petugas,
    this.status,
    this.created_at,
    this.updated_at,
  });

  RedeemedReward.fromJson(Map<String, dynamic> json, {String? id})
      : this(
          id: id,
          reward: Reward.fromJson(json["reward"]),
          user: User.fromJson(json["user"]),
          petugas: User.fromJson(json["petugas"]),
          status: json["status"]! as String,
          created_at: json["created_at"]! as Timestamp,
          updated_at: json["updated_at"]! as Timestamp,
        );

  Map<String, dynamic> toJson() {
    return {
      "reward": reward,
      "user": user,
      "petugas": petugas,
      "status": status,
      "created_at": created_at,
      "updated_at": updated_at,
    };
  }
}
