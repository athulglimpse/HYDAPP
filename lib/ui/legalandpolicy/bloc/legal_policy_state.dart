import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class LegalPolicyState extends Equatable {
  LegalPolicyState();

  factory LegalPolicyState.initial() {
    return LegalPolicyState();
  }

  LegalPolicyState copyWith({
    String email,
  }) {
    return LegalPolicyState();
  }

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return '''MyFormState {
    }''';
  }
}
