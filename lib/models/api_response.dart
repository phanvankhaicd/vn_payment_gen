class ApiResponse<T> {
  final String code;
  final String desc;
  final T data;

  ApiResponse({
    required this.code,
    required this.desc,
    required this.data,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      code: json['code'],
      desc: json['desc'],
      data: fromJsonT(json['data']),
    );
  }

  bool get isSuccess => code == '00';
} 