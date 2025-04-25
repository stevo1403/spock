class NFT {
  final String id;
  final String name;
  final String collection;
  final String image;
  final String price;
  final String currency;
  final String creator;
  final int likes;
  bool isLiked;

  NFT({
    required this.id,
    required this.name,
    required this.collection,
    required this.image,
    required this.price,
    required this.currency,
    required this.creator,
    required this.likes,
    this.isLiked = false,
  });

  factory NFT.fromJson(Map<String, dynamic> json) {
    return NFT(
      id: json['id'],
      name: json['name'],
      collection: json['collection'],
      image: json['image'],
      price: json['price'],
      currency: json['currency'],
      creator: json['creator'],
      likes: json['likes'],
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'collection': collection,
      'image': image,
      'price': price,
      'currency': currency,
      'creator': creator,
      'likes': likes,
      'isLiked': isLiked,
    };
  }

  NFT copyWith({
    String? id,
    String? name,
    String? collection,
    String? image,
    String? price,
    String? currency,
    String? creator,
    int? likes,
    bool? isLiked,
  }) {
    return NFT(
      id: id ?? this.id,
      name: name ?? this.name,
      collection: collection ?? this.collection,
      image: image ?? this.image,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      creator: creator ?? this.creator,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class NFTCollection {
  final String id;
  final String name;
  final String image;
  final String floorPrice;
  final String currency;
  final String volume;
  final int items;

  NFTCollection({
    required this.id,
    required this.name,
    required this.image,
    required this.floorPrice,
    required this.currency,
    required this.volume,
    required this.items,
  });

  factory NFTCollection.fromJson(Map<String, dynamic> json) {
    return NFTCollection(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      floorPrice: json['floorPrice'],
      currency: json['currency'],
      volume: json['volume'],
      items: json['items'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'floorPrice': floorPrice,
      'currency': currency,
      'volume': volume,
      'items': items,
    };
  }
}