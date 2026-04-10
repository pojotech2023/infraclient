import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'locale_event.dart';
import 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String _boxName = 'locale_settings';
  static const String _kLanguageCode = 'language_code';

  LocaleBloc() : super(const LocaleState.initial()) {
    on<LocaleInitialized>(_onLocaleInitialized);
    on<LocaleChanged>(_onLocaleChanged);
  }

  Future<void> _onLocaleInitialized(
    LocaleInitialized event,
    Emitter<LocaleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final Box box = await Hive.openBox(_boxName);
      final String languageCode = (box.get(_kLanguageCode) as String?) ?? 'en';
      
      emit(state.copyWith(
        languageCode: languageCode,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLocaleChanged(
    LocaleChanged event,
    Emitter<LocaleState> emit,
  ) async {
    emit(state.copyWith(languageCode: event.languageCode));
    
    try {
      final Box box = await Hive.openBox(_boxName);
      await box.put(_kLanguageCode, event.languageCode);
    } catch (e) {
      // Handle error silently
    }
  }
}
