class ApiEnvelope {
  const ApiEnvelope({
    required this.error,
    required this.message,
    this.data,
  });

  final bool error;
  final String message;
  final dynamic data;

  factory ApiEnvelope.fromJson(Map<String, dynamic> json) {
    return ApiEnvelope(
      error: json['error'] == true,
      message: json['message'] as String? ?? '',
      data: json['data'],
    );
  }
}
