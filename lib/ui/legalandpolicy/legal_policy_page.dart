import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../common/di/injection/injector.dart';
import '../../common/theme/theme.dart';
import '../../common/widget/my_text_view.dart';
import '../../utils/navigate_util.dart';
import '../base/base_widget.dart';
import 'bloc/legal_policy_bloc.dart';
import 'bloc/legal_policy_state.dart';

class LegalPolicyPage extends BaseWidget {
  static const routeName = 'LegalPolicyPage';
  final String title;
  final String html;

  LegalPolicyPage({this.title, this.html});

  @override
  State<StatefulWidget> createState() {
    return LegalPolicyPageState();
  }
}

class LegalPolicyPageState extends BaseState<LegalPolicyPage> {
  final LegalPolicyBloc _legalPolicyBloc = sl<LegalPolicyBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _legalPolicyBloc,
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
                text: widget.title,
              ),
            ),
            body: BlocBuilder<LegalPolicyBloc, LegalPolicyState>(
                builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(sizeNormal),
                    child: SingleChildScrollView(
                        child: HtmlWidget(widget.html ?? '')),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _legalPolicyBloc.close();
    super.dispose();
  }
}
