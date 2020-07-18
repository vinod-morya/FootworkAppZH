import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/custom_widget/NoDataWidget.dart';
import 'package:footwork_chinese/model/HistoryItemModel.dart';
import 'package:footwork_chinese/ui/favouriteVideos/FavouriteVideos.dart';
import 'package:footwork_chinese/ui/history/HistoryListItem.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryItemModel> listOfItem = List();
  FmFit fit = FmFit(width: 750);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    if (listOfItem.length == 0) {
      HistoryItemModel modelFavourite = HistoryItemModel();
      modelFavourite.title =
          AppLocalizations.of(context).translate("favourite_label");
      modelFavourite.icon = Icons.star;
      listOfItem.add(modelFavourite);

      HistoryItemModel modelNeedWork = HistoryItemModel();
      modelNeedWork.title = AppLocalizations.of(context).translate("need_work");
      modelNeedWork.icon = Icons.warning;
      listOfItem.add(modelNeedWork);

      HistoryItemModel modelCompleted = HistoryItemModel();
      modelCompleted.title =
          AppLocalizations.of(context).translate("completed_label");
      modelCompleted.icon = Icons.check_box;
      listOfItem.add(modelCompleted);

      listOfItem.add(HistoryItemModel());
    }
    return Container(
      color: Color(0xFFebebec),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return index == (listOfItem.length - 1)
                ? NoDataWidget(
                    fit: fit,
                    txt: AppLocalizations.of(context)
                        .translate("reach_end_text"),
                  )
                : HistoryListItem(
                    fit: fit,
                    data: listOfItem[index],
                    pos: index,
                    onclickItem: _onclickItem);
          },
          itemCount: listOfItem.length,
        ),
      ),
    );
  }

  _onclickItem(pos) {
    switch (pos) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FavouriteVideosList(
                videoType: "1",
                title:
                    AppLocalizations.of(context).translate('favourite_videos'),
                noDataText:
                    AppLocalizations.of(context).translate("no_favourites"))));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FavouriteVideosList(
                videoType: "2",
                title: AppLocalizations.of(context).translate('need_work'),
                noDataText:
                    AppLocalizations.of(context).translate("no_videos"))));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => FavouriteVideosList(
                videoType: "3",
                title:
                    AppLocalizations.of(context).translate('completed_label'),
                noDataText:
                    AppLocalizations.of(context).translate("no_videos"))));
        break;
    }
  }
}
