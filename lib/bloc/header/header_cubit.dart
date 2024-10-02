import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'header_state.dart';

class HeaderCubit extends Cubit<HeaderState> {
  HeaderCubit() : super(HeaderState(collapsed: false));

  void setCollapsed(bool collapsed) {
    emit(state.copyWith(collapsed: collapsed));
  }
}
