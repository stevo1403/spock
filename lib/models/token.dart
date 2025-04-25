class Token {
  final String name;
  final String symbol;
  final int decimals;
  final String address;
  final String logoURI;
  final int chainId;
  final Map<String, dynamic>? extensions;
  final List<String>? tags;

  Token({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.address,
    required this.logoURI,
    required this.chainId,
    this.extensions,
    this.tags,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      name: json['name'],
      symbol: json['symbol'],
      decimals: json['decimals'],
      address: json['address'],
      logoURI: json['logoURI'],
      chainId: json['chainId'],
      extensions: json['extensions'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'decimals': decimals,
      'address': address,
      'logoURI': logoURI,
      'chainId': chainId,
      'extensions': extensions,
      'tags': tags,
    };
  }
}

class TokenBalance {
  final Token token;
  final String balance;
  final String? balanceUsd;
  final String? price;
  final String? priceChange24h;

  TokenBalance({
    required this.token,
    required this.balance,
    this.balanceUsd,
    this.price,
    this.priceChange24h,
  });

  factory TokenBalance.fromJson(Map<String, dynamic> json) {
    return TokenBalance(
      token: Token.fromJson(json['token']),
      balance: json['balance'],
      balanceUsd: json['balanceUsd'],
      price: json['price'],
      priceChange24h: json['priceChange24h'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token.toJson(),
      'balance': balance,
      'balanceUsd': balanceUsd,
      'price': price,
      'priceChange24h': priceChange24h,
    };
  }
}