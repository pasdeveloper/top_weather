part of 'forecast_cubit.dart';

enum ForecastStatus { empty, loading, ok, error }

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
}
