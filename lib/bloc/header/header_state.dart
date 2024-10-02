part of 'header_cubit.dart';

class HeaderState extends Equatable {
  final bool collapsed;
  const HeaderState({
    required this.collapsed,
  });

  @override
  List<Object> get props => [collapsed];

  @override
  String toString() => 'HeaderState(collapsed: $collapsed)';

  HeaderState copyWith({
    bool? collapsed,
  }) {
    return HeaderState(
      collapsed: collapsed ?? this.collapsed,
    );
  }
}
