class Bank {
  final int id;
  final String name;
  final String code;
  final String bin;
  final String shortName;
  final String logo;
  final int transferSupported;
  final int lookupSupported;

  Bank({
    required this.id,
    required this.name,
    required this.code,
    required this.bin,
    required this.shortName,
    required this.logo,
    required this.transferSupported,
    required this.lookupSupported,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      bin: json['bin'],
      shortName: json['shortName'],
      logo: json['logo'],
      transferSupported: json['transferSupported'],
      lookupSupported: json['lookupSupported'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'bin': bin,
      'shortName': shortName,
      'logo': logo,
      'transferSupported': transferSupported,
      'lookupSupported': lookupSupported,
    };
  }

  Bank copyWith({
    int? id,
    String? name,
    String? code,
    String? bin,
    String? shortName,
    String? logo,
    int? transferSupported,
    int? lookupSupported,
  }) {
    return Bank(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      bin: bin ?? this.bin,
      shortName: shortName ?? this.shortName,
      logo: logo ?? this.logo,
      transferSupported: transferSupported ?? this.transferSupported,
      lookupSupported: lookupSupported ?? this.lookupSupported,
    );
  }
}
