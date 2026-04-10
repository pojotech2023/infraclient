import 'package:equatable/equatable.dart';

class LocaleState extends Equatable {
  final String languageCode;
  final bool isLoading;

  const LocaleState({
    required this.languageCode,
    this.isLoading = false,
  });

  const LocaleState.initial()
      : languageCode = 'en',
        isLoading = false;

  LocaleState copyWith({
    String? languageCode,
    bool? isLoading,
  }) {
    return LocaleState(
      languageCode: languageCode ?? this.languageCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [languageCode, isLoading];
}
