part of 'forecast_cubit.dart';

enum ForecastStatus {
  empty,
  loading,
  ok,
  error;

  String toMap() => name;
  static ForecastStatus fromMap(String name) => values.byName(name);
}

class ForecastState extends Equatable {
  final Forecast forecast;
  final ForecastStatus status;
  final String error;
  const ForecastState({
    required this.forecast,
    required this.status,
    this.error = '',
  });

  ForecastState copyWith({
    Forecast? forecast,
    ForecastStatus? status,
    String? error,
  }) {
    return ForecastState(
      forecast: forecast ?? this.forecast,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  factory ForecastState.initial() {
    return ForecastState(
      forecast: Forecast.empty(),
      status: ForecastStatus.empty,
    );
  }

  @override
  String toString() =>
      'ForecastState(forecast: $forecast, status: $status, error: $error)';

  @override
  List<Object> get props => [forecast, status, error];

  Map<String, dynamic> toMap() {
    return {
      'forecast': forecast.toMap(),
      'status': status.toMap(),
      'error': error,
    };
  }

  factory ForecastState.fromMap(Map<String, dynamic> map) {
    return ForecastState(
      forecast: Forecast.fromMap(map['forecast']),
      status: ForecastStatus.fromMap(map['status']),
      error: map['error'] ?? '',
    );
  }
}
