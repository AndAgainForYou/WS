import 'package:equatable/equatable.dart';
import 'package:ws_test/core/constants/app_constants.dart';

class HomeState extends Equatable {
  const HomeState({
    this.url = AppConstants.defaultApiUrl,
    this.urlError,
    this.isSaving = false,
  });

  final String url;
  final String? urlError;
  final bool isSaving;

  HomeState copyWith({
    String? url,
    String? urlError,
    bool clearUrlError = false,
    bool? isSaving,
  }) {
    return HomeState(
      url: url ?? this.url,
      urlError: clearUrlError ? null : (urlError ?? this.urlError),
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [url, urlError, isSaving];
}
