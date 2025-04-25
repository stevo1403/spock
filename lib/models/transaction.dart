class Transaction {
  final String id;
  final String type; // 'send', 'receive', 'swap', 'approve'
  final String status; // 'completed', 'pending', 'failed'
  final String amount;
  final String token;
  final String tokenSymbol;
  final int timestamp;
  final String from;
  final String to;
  final String hash;
  final String fee;

  Transaction({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.token,
    required this.tokenSymbol,
    required this.timestamp,
    required this.from,
    required this.to,
    required this.hash,
    required this.fee,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      amount: json['amount'],
      token: json['token'],
      tokenSymbol: json['tokenSymbol'],
      timestamp: json['timestamp'],
      from: json['from'],
      to: json['to'],
      hash: json['hash'],
      fee: json['fee'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'amount': amount,
      'token': token,
      'tokenSymbol': tokenSymbol,
      'timestamp': timestamp,
      'from': from,
      'to': to,
      'hash': hash,
      'fee': fee,
    };
  }
}