import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../common/di/injection/injector.dart';
import '../../common/dialog/cupertino_picker.dart';
import '../../common/dialog/cupertino_picker_photo.dart';
import '../../common/dialog/help_report_dialog.dart';
import '../../common/localization/lang.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_button.dart';
import '../../common/widget/my_text_view.dart';
import '../../data/model/help_report_model.dart';
import '../../utils/navigate_util.dart';
import '../../utils/ui_util.dart';
import '../base/base_widget.dart';
import '../congratulation_register/congratulation_regiter_page.dart';
import 'bloc/report_bloc.dart';
import 'util/report_util.dart';

class ReportPage extends BaseWidget {
  static const routeName = 'ReportPage';

  ReportPage();

  @override
  State<StatefulWidget> createState() {
    return ReportPageState();
  }
}

class ReportPageState extends BaseState<ReportPage> {
  final _helpBloc = sl<ReportBloc>();
  final FocusNode _focusDescription = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  ProgressDialog _pbLoading;

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    _helpBloc.add(GetReportItems());
    _descriptionController.addListener(_onDescriptionChanged);
    _helpBloc.listen((state) {
      if (state.isSuccessReport) {
        // UIUtil.showToast(Lang.report_your_issue_is_successfully_submitted.tr());
        NavigateUtil.replacePage(
            context, CongratulationRegisterScreen.routeName,
            argument: {'type': CongratulationEnum.REPORT});
      } else if (state.isError) {
        NavigateUtil.replacePage(
            context, CongratulationRegisterScreen.routeName,
            argument: {'type': CongratulationEnum.ERROR});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _pbLoading = ProgressDialog(context, showLogs: true);
    _pbLoading.style(message: Lang.started_loading_please_wait.tr());
    if (_helpBloc.state.reportItems == null ||
        _helpBloc.state.reportItems.isEmpty) {
      _pbLoading.show();
    }
    return BlocProvider(
      create: (_) => _helpBloc,
      child: Container(
        color: const Color(0xffFDFBF5),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xffFDFBF5),
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                iconSize: sizeSmallxxx,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  NavigateUtil.pop(context);
                },
              ),
              elevation: 0,
              backgroundColor: const Color(0xffFDFBF5),
              title: MyTextView(
                textStyle: textNormal.copyWith(
                    color: Colors.black,
                    fontFamily: MyFontFamily.publicoBanner,
                    fontWeight: MyFontWeight.bold),
                text: Lang.community_detail_report_issue.tr(),
              ),
            ),
            body: BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: SingleChildScrollView(
                        child: Container(
                          color: const Color(0xffFDFBF5),
                          padding: const EdgeInsets.all(sizeNormalxx),
                          child: Column(
                            children: [
                              renderDescription(state),
                              Container(
                                margin:
                                    const EdgeInsets.only(bottom: sizeSmallxxx),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: MyButton(
                                    paddingHorizontal: sizeImageSmall,
                                    onTap: () {
                                      submitReport(state);
                                    },
                                    text: Lang.help_send.tr(),
                                    isFillParent: false,
                                    textStyle: textNormal.copyWith(
                                        color: Colors.white),
                                    buttonColor: const Color(0xff242655),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget renderDescription(ReportState state) {
    return Form(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => showDialogIssue(context, state),
            child: Container(
              margin: const EdgeInsets.only(top: sizeSmall),
              padding: const EdgeInsets.all(sizeSmall + 1),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset:
                          const Offset(0, 0.5), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(sizeSmall))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        MyTextView(
                          textAlign: TextAlign.start,
                          text: Lang.report_choose_type_of_issue.tr(),
                          textStyle: textSmall.copyWith(
                              color: const Color(0x32212237)),
                        ),
                        MyTextView(
                          textAlign: TextAlign.start,
                          text: state?.issueSelected?.name ?? '....',
                          textStyle: textSmallxx.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      child: Icon(Icons.keyboard_arrow_down,
                          size: sizeSmallxxxx,
                          color: const Color(0xff212237).withOpacity(0.5))),
                ],
              ),
            ),
          ),
          const SizedBox(height: sizeSmallxxx),
          Container(
            margin: const EdgeInsets.only(top: sizeSmall),
            padding: const EdgeInsets.all(sizeVerySmall),
            decoration: BoxDecoration(
              boxShadow: [
                _focusDescription.hasFocus ?? false
                    ? BoxShadow(
                        color: const Color(0xffFDCB6B).withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      )
                    : BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.5,
                        blurRadius: 0.5,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      ),
              ],
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(sizeSmall)),
            ),
            child: TextField(
              focusNode: _focusDescription,
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 200,
              autocorrect: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFffffff),
              ),
            ),
          ),
          !(state?.isDesValid ?? false)
              ? Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                      left: sizeSmall, top: sizeVerySmall),
                  child: MyTextView(
                    textAlign: TextAlign.start,
                    text: Lang.help_please_input_at_least_10_characters.tr(),
                    textStyle: textSmall.copyWith(color: Colors.redAccent),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: sizeLarge),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: sizeNormalxx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyTextView(
                  text: Lang.community_write_review_add_photos
                      .tr()
                      .format([state.listImageSelected?.length.toString()]),
                  textStyle: textSmallx.copyWith(
                      color: const Color(0xff212237),
                      fontFamily: MyFontFamily.graphik,
                      fontWeight: MyFontWeight.medium),
                ),
                Container(
                  margin: const EdgeInsets.only(top: sizeSmallxxx),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          onAddImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              color: const Color(0xff212237).withOpacity(0.1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(sizeSmallxxx))),
                          padding: const EdgeInsets.all(sizeNormal),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: sizeLarge,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: sizeExLarge,
                          child: ListView.builder(
                              itemCount: state.listImageSelected?.length ?? 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.all(sizeVerySmall),
                                      margin:
                                          const EdgeInsets.all(sizeVerySmall),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(sizeVerySmall)),
                                          border: Border.all(
                                            color: const Color(0xff212237)
                                                .withOpacity(0.04),
                                            width: 1.0,
                                          ),
                                          color: const Color(0xff212237)
                                              .withOpacity(0.04)),
                                      child: Center(
                                        child: Image.file(
                                          File(state.listImageSelected.entries
                                              .toList()[index]
                                              .value[WRITE_REVIEW_KEY_ID]),
                                          fit: BoxFit.cover,
                                          height: sizeImageLargexx,
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            onDeleteImage(state
                                                .listImageSelected.entries
                                                .toList()[index]
                                                .value[WRITE_REVIEW_KEY_ID]);
                                          },
                                          child: Container(
                                            width: sizeSmallxxxx,
                                            height: sizeSmallxxxx,
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      sizeNormalxxx),
                                                )),
                                            child: const Icon(
                                              Icons.clear,
                                              color: Colors.black,
                                              size: sizeSmallx,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDescriptionChanged() {
    _helpBloc.add(DescriptionChanged(description: _descriptionController.text));
  }

  void showDialogIssue(BuildContext context, ReportState state) {
    if (state.reportItems == null || state.reportItems.isEmpty) {
      return;
    }
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) => HelpReportDialog(
          list: state.reportItems,
          itemSelected: state.issueSelected,
          onSelectItem: onSelectTypeIssue,
        ),
      );
    } else {
      showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext builder) {
          return CupertinoPickerView(
            listData: state.reportItems,
            positionSelected: state.reportItems.indexOf(state.issueSelected),
            onSelectedItemChanged: (value) =>
                onSelectTypeIssue(state.reportItems[value]),
            listWidget: List<Widget>.generate(state.reportItems?.length ?? 0,
                (int index) {
              return Center(
                child: MyTextView(
                  text: state.reportItems[index].name,
                  textStyle: textSmallxxx.copyWith(
                      color: Colors.black,
                      fontFamily: Fonts.Helvetica,
                      fontWeight: MyFontWeight.regular),
                ),
              );
            }),
          );
        },
      );
    }
  }

  void onAddImage() {
    FocusScope.of(context).unfocus();
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoPickerPhotoView(
            onSelectPhotos: onSelectPhotos, onSelectPhoto: onSelectPhoto));
  }

  void submitReport(ReportState state) {
    if (_descriptionController.text.length < 10) {
      UIUtil.showToast(Lang.help_please_input_at_least_10_characters.tr(),
        backgroundColor: Colors.red,);
      return;
    }
    _helpBloc.add(SubmitReport(
        des: _descriptionController.text,
        helpReportModel: state.issueSelected));
  }

  void onSelectPhotos(List<String> path) {
    _helpBloc.add(AddImageReports(path));
  }

  void onSelectPhoto(String path) {
    _helpBloc.add(AddImageReport(path));
  }

  void onDeleteImage(String value) {
    _helpBloc.add(DeleteImageReport(value));
  }

  void onSelectTypeIssue(HelpReportModel newValue) {
    _helpBloc.add(OnSelectTypeIssue(typeIssue: newValue));
  }

  @override
  void dispose() {
    _helpBloc.close();
    _focusDescription.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
