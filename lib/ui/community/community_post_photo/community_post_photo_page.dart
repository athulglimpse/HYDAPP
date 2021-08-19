import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marvista/utils/ui_util.dart';

import '../../../common/di/injection/injector.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_button.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../utils/app_const.dart';
import '../../../utils/location_wrapper.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../base/base_widget.dart';
import '../community_congratulation/community_congratulation_page.dart';
import 'bloc/community_post_photo_bloc.dart';

class CommunityPostPhotoPage extends BaseWidget {
  static const routeName = '/CommunityPostPhotoPage';
  final String pathImage;
  final String id;

  CommunityPostPhotoPage({
    this.pathImage,
    this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return CommunityPostPhotoPageState();
  }
}

class CommunityPostPhotoPageState extends BaseState<CommunityPostPhotoPage> {
  final _communityPostPhotoBloc = sl<CommunityPostPhotoBloc>();
  final FocusNode _focusDescription = FocusNode();
  final TextEditingController _descriptionController = TextEditingController();
  final locationWrapper = sl<LocationWrapper>();

  @override
  void initState() {
    super.initState();
    initBasicInfo();
    initLocationService();
  }

  void initBasicInfo() {
    _communityPostPhotoBloc.add(AddImagePost(widget.pathImage));
    _descriptionController.addListener(_onDescriptionChanged);

    _communityPostPhotoBloc.listen((state) {
      switch (state.currentRoute) {
        case PostPhotoRoute.enterCongratulation:
          NavigateUtil.replacePage(
              context, CommunityCongratulationScreen.routeName,
              argument: {
                'title': Lang
                    // ignore: lines_longer_than_80_chars
                    .community_post_photo_congratulation_you_post_was_successfully
                    .tr(),
                'description': Lang.community_post_photo_you_can_check_post.tr()
              });
          break;
        default:
      }
    });
  }

  Future<void> initLocationService() async {
    final hasPermission = await locationWrapper.requestPermission();
    if (!hasPermission) {
      return;
    }
    final locationData = await locationWrapper.locationData();
    _communityPostPhotoBloc.add(SearchLocation(
        lat: locationData?.latitude ?? DEFAULT_LOCATION_LAT,
        long: locationData?.longitude ?? DEFAULT_LOCATION_LONG,
        id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _communityPostPhotoBloc,
      child: BlocBuilder<CommunityPostPhotoBloc, CommunityPostPhotoState>(
          builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return renderPostPhotoForm(state);
          },
        );
      }),
    );
  }

  Widget renderPostPhotoForm(CommunityPostPhotoState state) {
    return Container(
      color: const Color(0xffFDFBF5),
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              color: const Color.fromARGB(255, 250, 251, 243),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    renderHeader(),
                    renderBody(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onPathImage(String path) {
    _communityPostPhotoBloc.add(AddImagePost(path));
  }

  void _onDescriptionChanged() {
    print(_descriptionController.text);
  }

  Widget renderHeader() {
    return Container(
      height: sizeExLarge,
      padding: const EdgeInsets.all(sizeSmallxxx),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              NavigateUtil.pop(context);
            },
            child: Container(
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: sizeSmallxxx,
              ),
            ),
          ),
          Expanded(
            child: MyTextView(
              text: Lang.community_post_photo_post_title.tr(),
              textStyle: textNormal.copyWith(
                  color: const Color(0xff212237),
                  fontFamily: MyFontFamily.publicoBanner,
                  fontWeight: MyFontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderBody(CommunityPostPhotoState state) {
    return Column(
      children: [
        Image.file(
          File(state?.pathImage ?? ''),
          fit: BoxFit.cover,
          height: sizeImageLargexx,
        ),
        Container(
          padding:
              const EdgeInsets.only(left: sizeSmallxxx, right: sizeSmallxxx),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: sizeNormalx, bottom: sizeNormalx),
                padding: const EdgeInsets.all(sizeSmallxxx),
                decoration: BoxDecoration(
                    boxShadow: [
                      _focusDescription.hasFocus ?? false
                          ? BoxShadow(
                              color: const Color(0xffFDCB6B).withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: const Offset(
                                  0, 0.5), // changes position of shadow
                            )
                          : BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: const Offset(
                                  0, 0.5), // changes position of shadow
                            ),
                    ],
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(sizeSmall))),
                child: TextField(
                  focusNode: _focusDescription,
                  controller: _descriptionController,
                  maxLines: 3,
                  maxLength: 200,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Lang.community_post_photo_write_caption.tr(),
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: true,
                    fillColor: const Color(0xFFffffff),
                  ),
                ),
              ),
              Container(
                height: sizeLargexxx,
                margin: const EdgeInsets.only(bottom: sizeNormalxx),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: sizeSmallxxx,
                        ),
                        MyTextView(
                          text: Lang.community_post_photo_add_location.tr(),
                          textStyle: textSmallx.copyWith(
                              color: const Color(0xff212237),
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.regular),
                        ),
                        if ((state.amenities?.isEmpty ?? false) ||
                            (state.isRefreshing))
                          const SizedBox(
                              height: sizeNormal,
                              width: sizeNormal,
                              child: CircularProgressIndicator()),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: const Icon(
                              Icons.keyboard_arrow_right,
                              size: sizeSmallxxx,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.amenities?.isNotEmpty ?? false)
                      Expanded(
                        child: ListView.builder(
                            itemCount: state.amenities?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  _communityPostPhotoBloc.add(
                                      SelectedAmenity(state.amenities[index]));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(sizeVerySmall),
                                  margin: const EdgeInsets.all(sizeVerySmall),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeVerySmall)),
                                    border: Border.all(
                                      color: const Color(0xff212237)
                                          .withOpacity(0.04),
                                      width: 1.0,
                                    ),
                                    color: state.selectedAmenity ==
                                            state.amenities[index]
                                        ? const Color(0xff212237)
                                        : const Color(0xff212237)
                                            .withOpacity(0.04),
                                  ),
                                  child: Center(
                                    child: MyTextView(
                                      text: state.amenities[index]?.parent
                                              ?.title ??
                                          '',
                                      textStyle: textSmallx.copyWith(
                                        color: state.selectedAmenity ==
                                                state.amenities[index]
                                            ? Colors.white
                                            : const Color(0xff212237),
                                        fontFamily: MyFontFamily.graphik,
                                        fontWeight: MyFontWeight.regular,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                  ],
                ),
              ),
              MyButton(
                minWidth: sizeImageLarge,
                text: Lang.community_post_photo_post_photo.tr(),
                onTap: () {
                  if (state.selectedAmenity == null) {
                    UIUtil.showToast(
                        Lang.community_you_need_select_an_location.tr());
                    return;
                  }
                  _communityPostPhotoBloc.add(SubmitPostPhoto(
                      _descriptionController.text,
                      state.selectedAmenity?.parent?.id.toString() ?? ''));
                },
                isFillParent: false,
                textStyle: textNormal.copyWith(color: Colors.white),
                buttonColor: const Color(0xff242655),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _communityPostPhotoBloc.close();
    super.dispose();
  }
}
