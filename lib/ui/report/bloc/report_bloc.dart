import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/localization/lang.dart';
import '../../../data/model/help_report_model.dart';
import '../../../data/model/update_model.dart';
import '../../../data/repository/config_repository.dart';
import '../../../data/repository/help_report_repository.dart';
import '../../../data/source/upload_photo.dart';
import '../../../utils/ui_util.dart';
import '../../community/community_write_review/util/community_write_review_util.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ConfigRepository configRepository;
  final HelpAndReportRepository helpAndReportRepository;

  ReportBloc({
    this.configRepository,
    this.helpAndReportRepository,
  }) : super(ReportState.initial(
          configRepository,
          helpAndReportRepository,
        ));

  @override
  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is AddImageReport) {
      if (state.listImageSelected.containsKey(event.path)) {
        return;
      }
      if (state.listImageSelected.isNotEmpty &&
          state.listImageSelected.length >= 3) {
        UIUtil.showToast(Lang.report_maximum_three_images.tr());
        return;
      }
      final filterValue = {};
      filterValue.addAll({
        WRITE_REVIEW_KEY_ID: event.path,
        WRITE_REVIEW_KEY_VALUE: event.path,
      });
      final mapFilter = <String, Map>{};
      mapFilter.addAll(state.listImageSelected);
      mapFilter[event.path] = filterValue;
      yield state.copyWith(listImageSelected: mapFilter);
    } else if (event is AddImageReports) {
      final mapFilter = <String, Map>{};
      event.path.forEach((element) {
        final filterValue = {};
        filterValue.addAll({
          WRITE_REVIEW_KEY_ID: element,
          WRITE_REVIEW_KEY_VALUE: element,
        });
        mapFilter[element] = filterValue;
      });
      yield state.copyWith(listImageSelected: mapFilter);
    } else if (event is DescriptionChanged) {
      yield state.copyWith(
          isDesValid:
              event.description.isEmpty || event.description.length >= 10);
    } else if (event is GetReportItems) {
      final result = await helpAndReportRepository.fetchReportItems();
      yield result.fold(
        (l) => state,
        (r) => state.copyWith(
            helpItems: r,
            issueSelected: (r != null && r.isNotEmpty) ? r[0] : state.issueSelected),
      );
    } else if (event is SubmitReport) {
      if (state.listImageSelected.isEmpty) {
        final re = await helpAndReportRepository.sendReportItems(
            event.des, event.helpReportModel.id.toString(), []);
        yield re.fold((l) => state.copyWith(isError: true),
            (r) => state.copyWith(isSuccessReport: true));
      } else {
        final file = <File>[];
        state.listImageSelected.entries.toList().forEach((element) {
          file.add(File(element.key));
        });
        final uploader = sl<UploadPhotos>();
        await uploader.uploadFile(UploadModel.init(
            file: file,
            dataPost: {
              'description': event.des,
              'issue_type': event.helpReportModel.id.toString(),
            },
            typePost: TypePost.ADD_REPORT_PHOTO));
        yield state.copyWith(isSuccessReport: true);
      }
    } else if (event is DeleteImageReport) {
      final mapImageSelected = <String, Map>{};
      mapImageSelected.addAll(state.listImageSelected);
      if (mapImageSelected.containsKey(event.id)) {
        mapImageSelected.remove(event.id);
      }
      yield state.copyWith(listImageSelected: mapImageSelected);
    } else if (event is OnSelectTypeIssue) {
      yield state.copyWith(issueSelected: event.typeIssue);
    }
  }
}
