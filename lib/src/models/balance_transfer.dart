import 'package:Serve_ios/src/models/payment_type.dart';

class BalanceTransfer {
  int balanceTypeId;
  String createdAt;
  PaymentType getType;
  int id;
  String notes;
  int orderId;
  int price;
  int siteProfits;
  int status;
  String updatedAt;
  int userId;

  BalanceTransfer(
      {this.balanceTypeId,
      this.createdAt,
      this.getType,
      this.id,
      this.notes,
      this.orderId,
      this.price,
      this.siteProfits,
      this.status,
      this.updatedAt,
      this.userId});

  factory BalanceTransfer.fromJson(Map<String, dynamic> json) {
    return BalanceTransfer(
      balanceTypeId: json['balance_type_id'],
      createdAt: json['created_at'],
      getType: json['get_type'] == null
          ? null
          : PaymentType.fromJson(json['get_type']),
      id: json['id'],
      notes: json['notes'],
      orderId: json['order_id'],
      price: json['price'],
      siteProfits: json['site_profits'],
      status: json['status'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance_type_id'] = this.balanceTypeId;
    data['created_at'] = this.createdAt;
    data['get_type'] = this.getType?.toJson();
    data['id'] = this.id;
    data['notes'] = this.notes;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
    data['site_profits'] = this.siteProfits;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    return data;
  }
}
