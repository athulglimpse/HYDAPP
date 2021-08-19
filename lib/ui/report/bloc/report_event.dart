part of 'report_bloc.dart';

@immutable
abstract class ReportEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetReportItems extends ReportEvent {}

class DescriptionChanged extends ReportEvent {
  final String description;

  DescriptionChanged({@required this.description});

  @override
  List<Object> get props => [description];
}

class SelectTypeIssue extends ReportEvent {
  final dynamic description;

  SelectTypeIssue({this.description});

  @override
  List<Object> get props => [description];
}

class DeleteImageReport extends ReportEvent {
  final String id;

  DeleteImageReport(this.id);
}
class AddImageReport extends ReportEvent {
  final String path;

  AddImageReport(this.path);
}

class AddImageReports extends ReportEvent {
  final List<String> path;

  AddImageReports(this.path);
}

class OnSelectTypeIssue extends ReportEvent {
  final HelpReportModel typeIssue;

  OnSelectTypeIssue({this.typeIssue});

  @override
  List<Object> get props => [typeIssue];
}

class SubmitReport extends ReportEvent {
  final HelpReportModel helpReportModel;
  final String des;

  SubmitReport({this.helpReportModel, this.des});
}
