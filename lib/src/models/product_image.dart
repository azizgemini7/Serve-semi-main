class ProductImage {
  int id;
  String photo;
  int productId;

  ProductImage({this.id, this.photo, this.productId});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      photo: json['photo'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    data['product_id'] = this.productId;
    return data;
  }
}
