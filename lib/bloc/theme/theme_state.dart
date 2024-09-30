part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  // enum
  final ThemeMode themeMode;
  const ThemeState({
    required this.themeMode,
  });

  @override
  List<Object> get props => [themeMode];

  @override
  String toString() => 'ThemeState(theme: $themeMode)';

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.index,
    };
  }

  factory ThemeState.fromMap(Map<String, dynamic> map) {
    return ThemeState(
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
    );
  }
}
