import 'package:dio/dio.dart';
import 'package:ws_test/core/error/exceptions.dart';
import 'package:ws_test/core/network/dio_error_mapper.dart';
import 'package:ws_test/core/utils/json_utils.dart';
import 'package:ws_test/data/models/api_envelope.dart';
import 'package:ws_test/data/models/path_task_dto.dart';

class PathTaskRemoteDataSource {
  const PathTaskRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PathTaskDto>> fetchTasks(String url) async {
    try {
      final response = await _dio.get<dynamic>(url);
      final envelope = ApiEnvelope.fromJson(asJsonMap(response.data));
      if (envelope.error) {
        throw ServerException(
          envelope.message.isEmpty ? 'Failed to fetch tasks' : envelope.message,
        );
      }
      final data = envelope.data;
      if (data is! List) {
        throw const ServerException('Unexpected response format');
      }
      return data.map(PathTaskDto.fromDynamic).toList();
    } on DioException catch (error) {
      throw ServerException(mapDioError(error));
    }
  }

  Future<void> sendResults({
    required String url,
    required List<Map<String, dynamic>> payload,
  }) async {
    try {
      final response = await _dio.post<dynamic>(url, data: payload);
      final envelope = ApiEnvelope.fromJson(asJsonMap(response.data));
      if (envelope.error) {
        throw ServerException(
          envelope.message.isEmpty
              ? 'Failed to send results'
              : envelope.message,
        );
      }

      final data = envelope.data;
      if (data is List) {
        final incorrectCount = data.where((item) {
          final map = asJsonMap(item);
          return map['correct'] == false;
        }).length;
        if (incorrectCount > 0) {
          throw ServerException(
            envelope.message.isEmpty
                ? 'Server rejected $incorrectCount result(s)'
                : envelope.message,
          );
        }
      }
    } on DioException catch (error) {
      throw ServerException(mapDioError(error));
    }
  }
}
