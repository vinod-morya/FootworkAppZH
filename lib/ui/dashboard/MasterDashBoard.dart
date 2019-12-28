import 'package:flutter/material.dart';
import 'package:fm_fit/fm_fit.dart';
import 'package:footwork_chinese/constants/app_colors.dart';
import 'package:footwork_chinese/constants/app_constants.dart';
import 'package:footwork_chinese/constants/app_images_path.dart';
import 'package:footwork_chinese/style/theme.dart';
import 'package:footwork_chinese/ui/editProfile/Profile.dart';
import 'package:footwork_chinese/ui/history/History.dart';
import 'package:footwork_chinese/ui/settings/Settings.dart';
import 'package:footwork_chinese/ui/userDashBoard/UserDashBoard.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class MasterDashboard extends StatefulWidget {
  @override
  _MasterDashboardState createState() => _MasterDashboardState();
}

class _MasterDashboardState extends State<MasterDashboard> {
  int _currentIndex = 0;
  final List<Widget> _children = [UserDashBoard(), History(), SettingsView()];
  FmFit fit = FmFit(width: 750);
  String title;

  @override
  Widget build(BuildContext context) {
    fit = FmFit(width: MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width > 600) {
      fit.scale = 1.0 + MediaQuery.of(context).size.aspectRatio;
    } else {
      fit.scale = 1.0;
    }
    if (_currentIndex == 0) {
      title = AppLocalizations.of(context).translate('app_name');
    }
    return Scaffold(
      appBar: _gradientAppBarWidget(),
      resizeToAvoidBottomInset: false,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: fit.t(22.0),
            ),
            activeIcon: Icon(
              Icons.home,
              size: fit.t(22.0),
              color: appColor,
            ),
            title: Text(
              AppLocalizations.of(context).translate('home'),
              style: TextStyle(
                fontFamily: robotoBoldFont,
                fontWeight: FontWeight.w600,
                fontSize: fit.t(12.0),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: fit.t(22.0),
            ),
            activeIcon: Icon(
              Icons.history,
              color: appColor,
              size: fit.t(22.0),
            ),
            title: Text(
              AppLocalizations.of(context).translate('history'),
              style: TextStyle(
                  fontFamily: robotoBoldFont,
                  fontWeight: FontWeight.w600,
                  fontSize: fit.t(12.0)),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                size: fit.t(22.0),
              ),
              activeIcon: Icon(
                Icons.settings,
                color: appColor,
                size: fit.t(22.0),
              ),
              title: Text(
                AppLocalizations.of(context).translate('settings_caps'),
                style: TextStyle(
                    fontFamily: robotoBoldFont,
                    fontWeight: FontWeight.w600,
                    fontSize: fit.t(12.0)),
              ))
        ],
      ),
    );
  }

  Widget _gradientAppBarWidget() {
    return GradientAppBar(
      gradient: ColorsTheme.dashBoardGradient,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: robotoBoldFont,
          fontWeight: FontWeight.w600,
          fontSize: fit.t(16.0),
        ),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileScreen(
                  AppLocalizations.of(context).translate('profile')),
              maintainState: true,
              fullscreenDialog: false)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: fit.t(40.0),
              height: fit.t(40.0),
              child: Image.asset(
                ic_profile,
                height: fit.t(45.0),
                width: fit.t(45.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      setTitle(index);
      _currentIndex = index;
    });
  }

  setTitle(int index) {
    switch (index) {
      case 0:
        title = AppLocalizations.of(context).translate('app_name');
        break;
      case 1:
        title = AppLocalizations.of(context).translate('history_label');
        break;
      case 2:
        title = AppLocalizations.of(context).translate('settings');
        break;
    }
  }
}
