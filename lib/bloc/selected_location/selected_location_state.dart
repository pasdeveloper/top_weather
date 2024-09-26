part of 'selected_location_bloc.dart';

class SelectedLocationState extends Equatable {
  final Location? selectedLocation;
  final bool triggerListener; // per triggerListener()

  const SelectedLocationState({
    this.triggerListener = false,
    this.selectedLocation,
  });

  factory SelectedLocationState.initial() {
    return const SelectedLocationState();
  }

  @override
  List<Object?> get props => [selectedLocation, triggerListener];

  @override
  String toString() =>
      'SelectedLocationState(selectedLocation: $selectedLocation, _triggerListener: $triggerListener)';

  SelectedLocationState copyWith({
    Location? selectedLocation,
    bool? triggerListener,
  }) {
    return SelectedLocationState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      triggerListener: triggerListener ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedLocation': selectedLocation?.toMap(),
      '_triggerListener': false,
    };
  }

  factory SelectedLocationState.fromMap(Map<String, dynamic> map) {
    return SelectedLocationState(
      selectedLocation: map['selectedLocation'] != null
          ? Location.fromMap(map['selectedLocation'])
          : null,
      triggerListener: false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectedLocationState.fromJson(String source) =>
      SelectedLocationState.fromMap(json.decode(source));
}
