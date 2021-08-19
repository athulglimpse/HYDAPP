import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:marvista/common/widget/search_empty_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/constants.dart';
import '../../../common/di/injection/injector.dart';
import '../../../common/dialog/cupertino_picker_photo.dart';
import '../../../common/localization/lang.dart';
import '../../../common/theme/theme.dart';
import '../../../common/widget/my_button.dart';
import '../../../common/widget/my_text_view.dart';
import '../../../data/model/asset_detail.dart';
import '../../../utils/navigate_util.dart';
import '../../../utils/ui_util.dart';
import '../../base/base_widget.dart';
import '../community_congratulation/community_congratulation_page.dart';
import 'bloc/community_write_review_bloc.dart';
import 'component/rating_bar.dart';
import 'util/community_write_review_util.dart';

class CommunityWriteReviewPage extends BaseWidget {
  static const routeName = '/CommunityWriteReviewPage';
  final String id;
  CommunityWriteReviewPage({
    this.id,
  });

  @override
  State<StatefulWidget> createState() {
    return CommunityWriteReviewPageState();
  }
}

class CommunityWriteReviewPageState extends BaseState<CommunityWriteReviewPage>
    with AfterLayoutMixin {
  final _communityWriteReviewBloc = sl<CommunityWriteReviewBloc>();
  final FocusNode _focusDescription = FocusNode();
  final FocusNode _focusSearch = FocusNode();
  Completer<List<AssetDetail>> _controller;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  double rating = 0.0;
  Timer timeDelay;

  @override
  void initState() {
    super.initState();
    initBasicInfo();
  }

  void initBasicInfo() {
    if (widget.id != null) {
      _communityWriteReviewBloc.add(FetchAssetDetail(widget.id));
    }
    _searchController.addListener(() {
      if (timeDelay != null && timeDelay.isActive) {
        timeDelay.cancel();
      }
      timeDelay = Timer(const Duration(milliseconds: 1000), () {
        getSuggestions(_searchController.text);
      });
    });

    _descriptionController.addListener(_onDescriptionChanged);
    _communityWriteReviewBloc.listen((state) {
      if (!(_controller?.isCompleted ?? false)) {
        _controller?.complete(state?.listAssetDetail);
      }
      switch (state.currentRoute) {
        case WriteReviewRoute.enterCongratulation:
          NavigateUtil.replacePage(
              context, CommunityCongratulationScreen.routeName,
              argument: {
                'title': Lang
                    .community_write_review_congratulation_you_review_was_successfully
                    .tr(),
                'description':
                    Lang.community_write_review_you_can_check_review.tr()
              });
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => _communityWriteReviewBloc,
      child: BlocBuilder<CommunityWriteReviewBloc, CommunityWriteReviewState>(
          builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return getLayoutByState(state);
          },
        );
      }),
    );
  }

  Widget getLayoutByState(CommunityWriteReviewState state) {
    switch (state.currentRoute) {
      case WriteReviewRoute.enterWriteReviewForm:
        return renderWriteReviewForm(state);
      default:
        return renderWriteReviewForm(state);
    }
  }

  Widget renderWriteReviewForm(CommunityWriteReviewState state) {
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
              child: Column(
                children: [
                  renderHeader(),
                  if (widget.id == null)
                    Container(
                      margin: const EdgeInsets.only(
                          right: sizeSmallxxx,
                          left: sizeSmallxxx,
                          bottom: sizeVerySmall),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffFDCB6B).withOpacity(0.5),
                              spreadRadius: 0.5,
                              blurRadius: 0.5,
                              offset: const Offset(
                                  0, 0.5), // changes position of shadow
                            )
                          ],
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(sizeSmall))),
                      child: TypeAheadField(
                        suggestionsBoxDecoration:
                            const SuggestionsBoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(sizeVerySmall),
                            bottomRight: Radius.circular(sizeVerySmall),
                          ),
                        ),
                        noItemsFoundBuilder: (context) {
                          return SearchEmptyWidget(
                            keyWord: _searchController.text,
                          );
                        },
                        debounceDuration: const Duration(milliseconds: 500),
                        textFieldConfiguration: TextFieldConfiguration(
                          autofocus: false,
                          focusNode: _focusSearch,
                          controller: _searchController,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(top: sizeSmallxx),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: Lang.asset_detail_try_starbucks.tr(),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                onClearText();
                              },
                              child: const Icon(Icons.clear),
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          if (_controller?.isCompleted ?? true) {
                            _controller = Completer();
                          }

                          return _controller.future;
                        },
                        getImmediateSuggestions: true,
                        itemBuilder: (context, AssetDetail item) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(sizeSmallxx),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(sizeIcon),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: sizeSmall),
                                      width: sizeNormalxx,
                                      height: sizeNormalxx,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            spreadRadius: 0.5,
                                            blurRadius: 0.5,
                                            offset: const Offset(0,
                                                0.5), // changes position of shadow
                                          )
                                        ],
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: UIUtil.makeCircleImageWidget(
                                          item?.thumb?.url ?? Res.img_temp_05,
                                          size: sizeNormal),
                                    ),
                                    Expanded(
                                      child: MyTextView(
                                        text: item.title,
                                        maxLine: 2,
                                        textAlign: TextAlign.start,
                                        textStyle: textSmallxx.copyWith(
                                            color: const Color(0xff212237),
                                            fontFamily: MyFontFamily.graphik,
                                            fontWeight: MyFontWeight.medium),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: sizeSmallxxx, right: sizeSmallxxx),
                                child: Divider(
                                  color:
                                      const Color(0xff212237).withOpacity(0.1),
                                ),
                              )
                            ],
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          onSuggestionSelected(suggestion);
                        },
                      ),
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: renderBody(state),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
              text: Lang.community_write_review_choose_place_review.tr(),
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

  Widget renderBody(CommunityWriteReviewState state) {
    return Container(
      padding: const EdgeInsets.all(sizeSmallxxx),
      child: Column(
        children: [
          renderContainerImage(state),
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
                    maxLines: 5,
                    maxLength: 200,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          Lang.community_write_review_write_your_review.tr(),
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
                  margin: const EdgeInsets.only(bottom: sizeSmallxxx),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextView(
                          textAlign: TextAlign.start,
                          text: Lang.community_write_review_tap_to_rate.tr(),
                          textStyle: textSmallx.copyWith(
                              color: const Color(0xff212237),
                              fontFamily: MyFontFamily.graphik,
                              fontWeight: MyFontWeight.medium),
                        ),
                      ),
                      RatingBar(
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          empty: const Icon(
                            Icons.star_border,
                            color: Color(0xff429C9B),
                          ),
                          half: const Icon(
                            Icons.star_half,
                            color: Color(0xff429C9B),
                          ),
                          full: const Icon(
                            Icons.star,
                            color: Color(0xff429C9B),
                          ),
                        ),
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (v) {
                          setState(() {
                            rating = v;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: sizeNormalxx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        text: Lang.community_write_review_add_photos
                            .tr()
                            .format(
                                [state.listImageSelected?.length.toString()]),
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
                              onTap: onAddImage,
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
                                    color: const Color(0xff212237)
                                        .withOpacity(0.1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(sizeSmallxxx))),
                                padding: const EdgeInsets.all(sizeNormal),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: sizeLarge,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: sizeExLarge,
                                child: ListView.builder(
                                    itemCount:
                                        state.listImageSelected?.length ?? 0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(
                                                sizeVerySmall),
                                            margin: const EdgeInsets.all(
                                                sizeVerySmall),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            sizeVerySmall)),
                                                border: Border.all(
                                                  color: const Color(0xff212237)
                                                      .withOpacity(0.04),
                                                  width: 1.0,
                                                ),
                                                color: const Color(0xff212237)
                                                    .withOpacity(0.04)),
                                            child: Center(
                                              child: Image.file(
                                                File(
                                                    state.listImageSelected
                                                            .entries
                                                            .toList()[index]
                                                            .value[
                                                        WRITE_REVIEW_KEY_ID]),
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
                                                  onDeleteImage(
                                                      state.listImageSelected
                                                              .entries
                                                              .toList()[index]
                                                              .value[
                                                          WRITE_REVIEW_KEY_ID]);
                                                },
                                                child: Container(
                                                  width: sizeSmallxxxx,
                                                  height: sizeSmallxxxx,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
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
                MyButton(
                  minWidth: sizeImageLarge,
                  text: Lang.community_write_review_submit_review.tr(),
                  onTap: () {
                    if (state.selectedAssetDetail == null) {
                      UIUtil.showToast(
                        Lang.asset_detail_please_choose_a_place_you_want_to_review
                            .tr(),
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    if (rating == 0) {
                      UIUtil.showToast(
                        Lang.asset_detail_rating_cannot_be_blank.tr(),
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    if (_descriptionController.text.isEmpty) {
                      UIUtil.showToast(
                        Lang.asset_review_cannot_be_blank.tr(),
                        backgroundColor: Colors.red,
                      );
                      return;
                    }
                    _communityWriteReviewBloc.add(SubmitWriteReview(
                        _descriptionController.text,
                        state.selectedAssetDetail.id.toString(),
                        rating,
                        state.selectedAssetDetail.experience.id.toString()));
                  },
                  isFillParent: false,
                  textStyle: textNormal.copyWith(color: Colors.white),
                  buttonColor: const Color(0xff242655),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderContainerImage(CommunityWriteReviewState state) {
    final item = state.selectedAssetDetail;
    return (state.selectedAssetDetail != null)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: sizeSmall),
                height: sizeImageNormalxxx + sizeNormalx,
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        bottom: sizeSmallxx,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(sizeVerySmall),
                          ),
                          child: UIUtil.makeImageWidget(
                              item.image?.url ?? Res.image_lorem,
                              boxFit: BoxFit.cover),
                        ),
                      ),
                      // Positioned.fill(
                      //   bottom: sizeSmall,
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child: Wrap(
                      //       children: [
                      //         UIUtil.makeCircleImageWidget(
                      //             item?.thumb?.url ?? Res.img_temp_05,
                      //             size: sizeImageNormalxxx * 0.3),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: sizeSmall, vertical: sizeVerySmall),
                            decoration: const BoxDecoration(
                              color: Color(0xffE6E4DE),
                              borderRadius: BorderRadius.all(
                                Radius.circular(sizeSmallxx),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rate,
                                  size: sizeSmallxxx,
                                  color: Color(0xffFBBC43),
                                ),
                                MyTextView(
                                  text: item?.rate ?? '0',
                                  textStyle: textSmall.copyWith(
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.medium),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTextView(
                        text: item.title,
                        textStyle: textSmallxxx,
                      ),
                      Container(
                        constraints: const BoxConstraints(
                            minWidth: sizeImageSmall,
                            maxWidth: sizeImageNormalxx),
                        child: MyTextView(
                          textAlign: TextAlign.start,
                          maxLine: 2,
                          text: item?.category?.name ?? '',
                          textStyle: textSmallxx.copyWith(
                              color: Colors.black.withOpacity(0.3)),
                        ),
                      ),
                    ],
                  ),
                  (item.eta != null)
                      ? Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: sizeNormal,
                              ),
                              SvgPicture.asset(
                                Res.icon_walk,
                                fit: BoxFit.contain,
                                color: Colors.grey,
                                width: sizeVerySmallx,
                              ),
                              const SizedBox(
                                width: sizeVerySmall,
                              ),
                              Flexible(
                                child: MyTextView(
                                  maxLine: 1,
                                  text: item.eta ?? '...',
                                  textStyle: textSmallx.copyWith(
                                      color: Colors.grey,
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.regular),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: sizeNormal,
                              ),
                              SvgPicture.asset(
                                Res.icon_car,
                                fit: BoxFit.contain,
                                color: Colors.grey,
                                width: sizeSmallxxx,
                              ),
                              const SizedBox(
                                width: sizeVerySmall,
                              ),
                              Flexible(
                                child: MyTextView(
                                  maxLine: 1,
                                  text: item.etaCar ?? '...',
                                  textStyle: textSmallx.copyWith(
                                      color: Colors.grey,
                                      fontFamily: MyFontFamily.graphik,
                                      fontWeight: MyFontWeight.regular),
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              )
            ],
          )
        : ((_controller != null)
            ? const SizedBox()
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                child: SvgPicture.asset(
                  Res.default_img_write_review,
                  fit: BoxFit.cover,
                  height: sizeImageNormalxxx + sizeNormalx,
                ),
              ));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _searchController.dispose();
    _focusSearch.dispose();
    _focusDescription.dispose();
    timeDelay?.cancel();
    _communityWriteReviewBloc.close();
    super.dispose();
  }

  void onAddImage() {
    FocusScope.of(context).unfocus();
    showCupertinoModalPopup(
        context: context,
        builder: (context) =>
            CupertinoPickerPhotoView(onSelectPhotos: onSelectPhotos));
  }

  void onSelectPhotos(List<String> paths) {
    _communityWriteReviewBloc.add(AddImageWriteReview(paths));
  }

  void onDeleteImage(String value) {
    _communityWriteReviewBloc.add(DeleteImageWriteReview(value));
  }

  void getSuggestions(String pattern) {
    _communityWriteReviewBloc.add(FetchSuggestionsAmenities(pattern));
  }

  void onSuggestionSelected(AssetDetail assetDetail) {
    _communityWriteReviewBloc.add(SelectedAssetDetail(assetDetail));
  }

  void onClearText() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    _communityWriteReviewBloc.add(FocusFieldSearch(_focusSearch.hasFocus));
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (widget.id == null) {
      await Future.delayed(const Duration(seconds: 1));
      FocusScope.of(context).requestFocus(_focusSearch);
    }
  }
}
