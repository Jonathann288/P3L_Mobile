import 'package:flutter_application_reusemart/entity/UserData.dart';
class MeResponse {
  final bool success;
  final UserData data;

  MeResponse({
    required this.success,
    required this.data,
  });

  factory MeResponse.fromJson(Map<String, dynamic> json) {
    return MeResponse(
      success: json['success'] ?? false,
      data: UserData.fromJson(json['data']),
    );
  }
}