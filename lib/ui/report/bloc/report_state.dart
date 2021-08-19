part of 'report_bloc.dart';

@immutable
class ReportState extends Equatable {
  final Map<String, Map> listImageSelected;
  final List<HelpReportModel> reportItems;
  final HelpReportModel issueSelected;
  final bool isSuccessReport;
  final bool isError;
  final bool isDesValid;

  ReportState(
      {this.listImageSelected,
      this.issueSelected,
      this.isDesValid,
      this.reportItems,
      this.isSuccessReport,
      this.isError});

  factory ReportState.initial(
    ConfigRepository configRepository,
    HelpAndReportRepository helpAndReportRepository,
  ) {
    final helpItems = helpAndReportRepository.getReportItems();
    return ReportState(
      listImageSelected: const <String, Map>{},
      reportItems: helpItems,
      isSuccessReport: false,
      isError: false,
      isDesValid: true,
      issueSelected:
          (helpItems != null && helpItems.isNotEmpty) ? helpItems[0] : null,
    );
  }

  ReportState copyWith({
    Map<String, Map> listImageSelected,
    HelpReportModel issueSelected,
    List<HelpReportModel> helpItems,
    List<HelpReportModel> reportItems,
    bool isSuccessReport,
    bool isError,
    bool isDesValid,
  }) {
    return ReportState(
      listImageSelected: listImageSelected ?? this.listImageSelected,
      issueSelected: issueSelected ?? this.issueSelected,
      reportItems: reportItems ?? this.reportItems,
      isDesValid: isDesValid ?? this.isDesValid,
      isSuccessReport: isSuccessReport ?? false,
      isError: isError ?? false,
    );
  }

  @override
  List<Object> get props => [
        listImageSelected,
        issueSelected,
        isDesValid,
        isError,
        reportItems,
        isSuccessReport,
      ];

  @override
  String toString() {
    return '''MyFormState {
    'listImageSelected':$listImageSelected,
    'issueSelected':$issueSelected
    'isSuccessReport':$isSuccessReport
    }''';
  }
}
