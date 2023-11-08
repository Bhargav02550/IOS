import 'dart:convert';

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  String name;
  String number;
  List<Item> items;

  Shop({
    required this.name,
    required this.number,
    required this.items,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        name: json["name"],
        number: json["number"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String itemname;
  String itemdis;
  String imageurl;
  String price;

  Item({
    required this.itemname,
    required this.itemdis,
    required this.imageurl,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemname: json["itemname"],
        itemdis: json["itemdis"],
        imageurl: json["imageurl"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "itemname": itemname,
        "itemdis": itemdis,
        "imageurl": imageurl,
        "price": price,
      };
}
