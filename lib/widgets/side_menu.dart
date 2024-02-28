// ignore_for_file: avoid_print

import 'package:admin_panel/constants/constants.dart';
import 'package:admin_panel/constants/controllers.dart';
import 'package:admin_panel/constants/style.dart';
import 'package:admin_panel/helpers/authentication.dart';
import 'package:admin_panel/pages/authentication/authentication.dart';
import 'package:admin_panel/widgets/custom_text.dart';
import 'package:admin_panel/widgets/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/responsiveness.dart';
import '../routing/routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: light,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(width: width / 48),
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 12),
                    //   child: Image.asset("assets/icons/logo.png"),
                    // ),
                    Flexible(
                      child: CustomText(
                        text: "Admin Panel",
                        size: 20,
                        weight: FontWeight.bold,
                        color: active,
                      ),
                    ),
                    SizedBox(width: width / 48),
                  ],
                ),
              ],
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: sideMenuItems
                .map((item) => SideMenuItem(
                    itemName: item.name == authenticationPageRoute
                        ? "Log Out"
                        : item.name,
                    onTap: () async {
                      //remove the cookie
                      CookieManager().removeCookie(Constants.cookieName);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      if (item.route == authenticationPageRoute) {
                        menuController
                            .changeActiveItemTo(overViewPageDisplayName);
                        Get.offAllNamed(authenticationPageRoute);
                      }
                      if (!menuController.isActive(item.name)) {
                        menuController.changeActiveItemTo(item.name);
                        if (ResponsiveWidget.isSmallScreen(context)) {
                          Get.back();
                        }
                        navigationController.navigateTo(item.route);
                      }
                    }))
                .toList(),
          )
        ],
      ),
    );
  }
}
