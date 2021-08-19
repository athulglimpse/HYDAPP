import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class Failure extends Equatable{
  @override
  List<Object> get props => [];
}

class RemoteDataFailure extends Failure {
  final String errorCode;
  final String errorMessage;

  RemoteDataFailure({@required this.errorCode, @required this.errorMessage});
}

class ExceptionDataFailure extends Failure {
  final String errorCode;
  final String errorMessage;

  ExceptionDataFailure({this.errorCode, @required this.errorMessage});
}

class NetworkFailure extends Failure {}

class NoResultFailure extends Failure {}
