import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? name;
  int? quantity;
  String? expiry;
  String? quality;
  int? categoryID;
  String? description;
  int? price;
  String? productID;
  int? sellerID;
  String? productImage;
  String? unit;
  bool? inStock;

  Product(
      {this.name,
        this.quantity,
        this.expiry,
        this.quality,
        this.categoryID,
        this.description,
        this.price,
        this.productID,
        this.sellerID,
        this.productImage,
        this.unit,
        this.inStock});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    quantity = json['quantity'];
    expiry = json['expiry'];
    quality = json['quality'];
    categoryID = json['categoryID'];
    description = json['description'];
    price = json['price'];
    productID = json['productID'];
    sellerID = json['sellerID'];
    productImage = json['productImage'];
    unit = json['unit'];
    inStock = json['inStock'];
  }


  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['expiry'] = expiry;
    data['quality'] = quality;
    data['categoryID'] = categoryID;
    data['description'] = description;
    data['price'] = price;
    data['productID'] = productID;
    data['sellerID'] = sellerID;
    data['productImage'] = productImage;
    data['unit'] = unit;
    data['inStock'] = inStock;
    return data;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['expiry'] = expiry;
    data['quality'] = quality;
    data['categoryID'] = categoryID;
    data['description'] = description;
    data['price'] = price;
    data['productID'] = productID;
    data['sellerID'] = sellerID;
    data['productImage'] = productImage;
    data['unit'] = unit;
    data['inStock'] = inStock;
    return data;
  }

  Product ProductFromList(dynamic data) {
    //final data = <String, dynamic>{};
    data['name'] = name;
    data['quantity'] = quantity;
    data['expiry'] = expiry;
    data['quality'] = quality;
    data['categoryID'] = categoryID;
    data['description'] = description;
    data['price'] = price;
    data['productID'] = productID;
    data['sellerID'] = sellerID;
    data['productImage'] = productImage;
    data['unit'] = unit;
    data['inStock'] = inStock;
    return data;
  }

  Product.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["name"],
        quantity = doc.data()!["quantity"],
        expiry = doc.data()!["expiry"],
        quality = doc.data()!["quality"],
        categoryID = doc.data()!["categoryID"],
        description = doc.data()!["description"],
        price = doc.data()!["price"],
        productID = doc.id,
        sellerID = doc.data()!["sellerID"],
        productImage = doc.data()!["productImage"],
        unit = doc.data()!["unit"],
        inStock = doc.data()?["inStock"];
}


