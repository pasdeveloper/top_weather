part of 'selected_location_bloc.dart';

abstract class SelectedLocationEvent extends Equatable {
  const SelectedLocationEvent();

  @override
  List<Object> get props => [];
}

class UpdateSelectedLocationEvent extends SelectedLocationEvent {
  final Location toSelect;
  const UpdateSelectedLocationEvent({
    required this.toSelect,
  });

  @override
  List<Object> get props => [toSelect];
}

class ClearSelectedLocationEvent extends SelectedLocationEvent {}

class TriggerListenerEvent extends SelectedLocationEvent {}
