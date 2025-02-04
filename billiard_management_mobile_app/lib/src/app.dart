import 'package:billiard_management_mobile_app/src/pages/admin/booking/booking_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/admin/food/food_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/admin/home.dart';
import 'package:billiard_management_mobile_app/src/pages/admin/table/table_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/admin/user/user_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/client/booking/booking_listview.dart';
import 'package:billiard_management_mobile_app/src/pages/client/home.dart';
import 'package:billiard_management_mobile_app/src/pages/login.dart';
import 'package:billiard_management_mobile_app/src/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  final SettingsController settingsController;

  const MyApp({
    @required this.token,
    required this.settingsController,
    Key? key,
  }) : super(key: key);

  // Hàm kiểm tra Default routes
  Widget _getDefaultPage() {
    if (token != null && JwtDecoder.isExpired(token) == false) {
      late String role;
      Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(token);
      role = jwtDecodedToken['role'];
      return ClientHomePage(token: token);
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',

          // Languges
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          // Themes
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          // Routes
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  // modify
                  case LoginPage.routeName:
                    return const LoginPage();
                  case SignUpPage.routeName:
                    return const SignUpPage();
                  case ClientHomePage.routeName:
                    return ClientHomePage(token: token);
                  case AdminFoodListView.routeName:
                    return const AdminFoodListView();
                  case AdminUserListView.routeName:
                    return const AdminUserListView();
                  default:
                    return _getDefaultPage();
                }
              },
            );
          },
        );
      },
    );
  }
}
