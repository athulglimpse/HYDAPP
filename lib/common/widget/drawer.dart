import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/user_info.dart';

class AppDrawer extends StatelessWidget {
  static const int PRODUCTS_TAB = 4;
  static const int HOME_TAB = 0;
  final int currentPage;
  final UserInfo _userInfo;

  AppDrawer(this.currentPage, this._userInfo);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.green[700],
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: const EdgeInsets.only(top: 40, bottom: 30),
          children: <Widget>[
            Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 100.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Text(
                _userInfo.fullName,
                textScaleFactor: 1.0, // disables accessibility
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            Container(
              color: currentPage == HOME_TAB
                  ? Colors.green[900]
                  : Colors.green[700],
              child: ListTile(
                title: const Text('Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                    )), // .tr(context: context),
                leading: const Icon(Icons.dashboard, color: Colors.white),
                onTap: () {},
              ),
            ),
            Container(
              color: currentPage == PRODUCTS_TAB
                  ? Colors.green[900]
                  : Colors.green[700],
              child: ListTile(
                title: const Text('Products',
                    style: TextStyle(
                      color: Colors.white,
                    )), //.tr(context: context),
                leading: const Icon(Icons.shopping_cart, color: Colors.white),
                onTap: () {},
              ),
            ),
            Container(
              color: currentPage == 1 ? Colors.green[900] : Colors.green[700],
              child: ListTile(
                title: const Text('Orders',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                leading: const Icon(Icons.shopping_basket, color: Colors.white),
                onTap: () {},
              ),
            ),
            Container(
              color: currentPage == 2 ? Colors.green[900] : Colors.green[700],
              child: ListTile(
                title: const Text('My Offers',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                leading: const Icon(Icons.bubble_chart, color: Colors.white),
                onTap: () {},
              ),
            ),
            Container(
              color: currentPage == 3 ? Colors.green[900] : Colors.green[700],
              child: ListTile(
                title: const Text('My Company',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                leading: const Icon(Icons.widgets, color: Colors.white),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
