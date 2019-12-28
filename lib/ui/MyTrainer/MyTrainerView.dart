import 'package:flutter/material.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class MyTrainerView extends StatefulWidget {
  final title;

  MyTrainerView(this.title);

  @override
  _MyTrainerViewState createState() => _MyTrainerViewState();
}

class _MyTrainerViewState extends State<MyTrainerView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _gradientAppBarWidget(),
      body: Container(
        decoration: BoxDecoration(gradient: ColorsTheme.dashBoardGradient),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Container()),
      ),
    );
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      title: Text(widget.title),
    );
  }
}
