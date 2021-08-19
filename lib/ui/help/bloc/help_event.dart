import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/model/country.dart';
import '../../../data/model/help_report_model.dart';

@immutable
abstract class HelpEvent extends Equatable {
  const HelpEvent();

  @override
  List<Object> get props => [];
}

class LoadCountryCode extends HelpEvent {}

class FetchHelpItems extends HelpEvent {}

class OnSelectHelpItem extends HelpEvent {
  final HelpReportModel helpItem;

  OnSelectHelpItem({this.helpItem});

  @override
  List<Object> get props => [helpItem];
}

class OnSelectCountryCode extends HelpEvent {
  final Country countryStatus;

  OnSelectCountryCode({@required this.countryStatus});

  @override
  List<Object> get props => [countryStatus];
}

class PhoneChanged extends HelpEvent {
  final String phone;

  PhoneChanged({@required this.phone});

  @override
  List<Object> get props => [phone];
}

class DesChanged extends HelpEvent {
  final String des;

  DesChanged({@required this.des});

  @override
  List<Object> get props => [des];
}

class EmailChanged extends HelpEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class DescriptionChanged extends HelpEvent {
  final String description;

  DescriptionChanged({@required this.description});

  @override
  List<Object> get props => [description];
}

class SendHelp extends HelpEvent {
  final String content;
  final String helpTopic;
  final String email;
  final String mobile;
  final String dialCode;

  SendHelp({
    this.content,
    this.helpTopic,
    this.email,
    this.mobile,
    this.dialCode,
  });

  @override
  List<Object> get props => [content, helpTopic, email, mobile, dialCode];
}
