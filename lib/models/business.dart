/// Thông tin doanh nghiệp
class Business {
  /// Mã số thuế
  final String id;
  
  /// Tên doanh nghiệp
  final String name;
  
  /// Tên quốc tế
  final String internationalName;
  
  /// Tên viết tắt
  final String shortName;
  
  /// Địa chỉ
  final String address;

  Business({
    required this.id,
    required this.name,
    required this.internationalName,
    required this.shortName,
    required this.address,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      internationalName: json['internationalName'] ?? '',
      shortName: json['shortName'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'internationalName': internationalName,
      'shortName': shortName,
      'address': address,
    };
  }
} 