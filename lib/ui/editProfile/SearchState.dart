import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/model/StateListResponse.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchState extends StatefulWidget {
  final List<StateListBean> countryList;

  SearchState(this.countryList);

  @override
  SearchStateState createState() => SearchStateState();
}

class SearchStateState extends State<SearchState> {
  String query = '';
  var _inputController = TextEditingController();
  List<StateListBean> countryList = List<StateListBean>();
  List<StateListBean> dummyListData = List<StateListBean>();
  var _blankFocusNode = FocusNode();
  FmFit fit = FmFit(width: 750);

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    return Scaffold(
      appBar: _gradientAppBarWidget(),
      body: Stack(
        children: <Widget>[
          _centerBody(),
        ],
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    countryList.clear();
    countryList.addAll(widget.countryList);
    dummyListData.addAll(widget.countryList);
    super.initState();
  }

  void callApiGetProjects(String query) {
    List<StateListBean> queryList = List<StateListBean>();
    dummyListData.forEach((item) {
      if (item.name.toLowerCase().contains(query)) {
        queryList.add(item);
      }
    });
    setState(() {
      countryList.clear();
      countryList.addAll(queryList);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      elevation: fit.t(2.0),
      leading: Material(
        shadowColor: Colors.transparent,
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(_blankFocusNode);
            Navigator.of(context).pop();
          },
        ),
      ),
      title: Theme(
        isMaterialAppTheme: true,
        data: ThemeData(
            primaryColor: Colors.white60,
            accentColor: Colors.white60,
            hintColor: Colors.white60,
            inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(color: Colors.white60))),
        child: StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              return TextField(
                controller: _inputController,
                cursorWidth: fit.t(1.0),
                cursorColor: Colors.white60,
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                keyboardAppearance: Brightness.light,
                onChanged: callApiGetProjects,
                decoration: InputDecoration(
                    hintMaxLines: 1,
                    border: InputBorder.none,
                    hoverColor: colorWhite,
                    focusColor: colorWhite,
                    fillColor: colorWhite,
                    hintText:
                    AppLocalizations.of(context).translate("search_state"),
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontFamily: regularFont,
                      fontSize: fit.t(18.0),
                    )),
                style: TextStyle(
                  color: colorWhite,
                  fontFamily: regularFont,
                  fontSize: fit.t(18.0),
                ),
              );
            }),
      ),
      centerTitle: true,
      gradient: ColorsTheme.dashBoardGradient,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            _inputController.text = query;
            countryList.clear();
            countryList.addAll(dummyListData);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget buildList(List<StateListBean> countryList) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: countryList.length,
      itemBuilder: (context, position) {
        return SearchProjectItem(
          position: position,
          item: countryList[position],
          onItemSelected: onItemSelected,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black12,
          height: fit.t(1.0),
        );
      },
    );
  }

  onItemSelected(int pos) {
    FocusScope.of(context).requestFocus(_blankFocusNode);
    Navigator.of(context).pop(countryList[pos]);
  }

  Widget _centerBody() {
    return buildList(countryList);
  }
}

class SearchProjectItem extends StatelessWidget {
  SearchProjectItem({this.position, this.item, this.onItemSelected});

  final Function(int pos) onItemSelected;
  final int position;
  final StateListBean item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onItemSelected(position),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              vertical: fit.t(2.0), horizontal: fit.t(8.0)),
          title: Text(item.name)),
    );
  }
}
