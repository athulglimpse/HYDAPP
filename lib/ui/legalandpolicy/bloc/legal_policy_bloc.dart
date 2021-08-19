import 'dart:async';

import 'package:bloc/bloc.dart';

import 'legal_policy_event.dart';
import 'legal_policy_state.dart';

class LegalPolicyBloc extends Bloc<LegalPolicyEvent, LegalPolicyState> {
  LegalPolicyBloc() : super(LegalPolicyState.initial());

  @override
  Stream<LegalPolicyState> mapEventToState(LegalPolicyEvent event) async* {}
}
