import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ws_test/domain/usecases/get_saved_api_url.dart';
import 'package:ws_test/domain/usecases/save_api_url.dart';
import 'package:ws_test/domain/usecases/validate_api_url.dart';
import 'package:ws_test/presentation/screens/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required ValidateApiUrl validateApiUrl,
    required GetSavedApiUrl getSavedApiUrl,
    required SaveApiUrl saveApiUrl,
  }) : _validateApiUrl = validateApiUrl,
       _getSavedApiUrl = getSavedApiUrl,
       _saveApiUrl = saveApiUrl,
       super(const HomeState());

  final ValidateApiUrl _validateApiUrl;
  final GetSavedApiUrl _getSavedApiUrl;
  final SaveApiUrl _saveApiUrl;

  void load() {
    final saved = _getSavedApiUrl();
    if (saved != null && saved.trim().isNotEmpty) {
      emit(state.copyWith(url: saved, clearUrlError: true));
    }
  }

  void onUrlChanged(String value) {
    emit(state.copyWith(url: value, clearUrlError: true));
  }

  Future<bool> submit() async {
    final error = _validateApiUrl(state.url);
    if (error != null) {
      emit(state.copyWith(urlError: error));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearUrlError: true));
    await _saveApiUrl(state.url);
    if (isClosed) {
      return false;
    }
    emit(state.copyWith(isSaving: false));
    return true;
  }
}
