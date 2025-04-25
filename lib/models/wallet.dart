class Wallet {
  final String id;
  final String name;
  final String address;
  final String shortAddress;
  final String balance;
  final String icon;
  final int chainId;
  final String network;

  Wallet({
    required this.id,
    required this.name,
    required this.address,
    required this.shortAddress,
    required this.balance,
    required this.icon,
    required this.chainId,
    required this.network,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      shortAddress: json['shortAddress'],
      balance: json['balance'],
      icon: json['icon'],
      chainId: json['chainId'],
      network: json['network'] ?? 'Ethereum Mainnet',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'shortAddress': shortAddress,
      'balance': balance,
      'icon': icon,
      'chainId': chainId,
      'network': network,
    };
  }
}

class Message {
  final String id;
  final String title;
  final String content;
  final int timestamp;
  bool read;

  Message({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    this.read = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      timestamp: json['timestamp'],
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'timestamp': timestamp,
      'read': read,
    };
  }
}

class Advertisement {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String ctaText;
  final String ctaUrl;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ctaText,
    required this.ctaUrl,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      ctaText: json['ctaText'],
      ctaUrl: json['ctaUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'ctaText': ctaText,
      'ctaUrl': ctaUrl,
    };
  }
}

class Exchange {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String url;
  final String type;

  Exchange({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.url,
    required this.type,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      url: json['url'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'url': url,
      'type': type,
    };
  }
}