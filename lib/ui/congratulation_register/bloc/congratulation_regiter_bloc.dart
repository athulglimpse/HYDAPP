import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'congratulation_regiter_event.dart';
part 'congratulation_regiter_state.dart';

class CongratulationRegisterBloc
    extends Bloc<CongratulationRegisterEvent, CongratulationRegisterState> {
  CongratulationRegisterBloc() : super(CongratulationRegisterInitial());

  @override
  Stream<CongratulationRegisterState> mapEventToState(
    CongratulationRegisterEvent event,
  ) async* {}
}
