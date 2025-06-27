import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:shop_online/admin/pages/admin_home.dart';
import 'package:shop_online/admin/pages/sold_product.dart';
import 'package:shop_online/admin/widgets/admin_google_nav_bar.dart';
import 'package:shop_online/core/core.dart';
import 'package:shop_online/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../pages/category_management.dart';
import '../pages/product_management.dart';

class AdminNavigation extends StatefulWidget {
  int selectedIndex = 0;
  AdminNavigation({super.key, required this.selectedIndex});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  //var _selectedIndex = 0;

  void onTabChange(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  List _pages = [AdminHome(), CategoryManagement(), ProductManagement(), SoldProduct()];

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return Container(
              //padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.sort,
                  color: Theme.of(context).colorScheme.primary,
                  size: getSize(30),
                ),
              ),
            );
          },
        ),
        actions: widget.selectedIndex == 0
        ? [
          Container(
            //padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: -5, end: -10),
              badgeStyle: badges.BadgeStyle(
                padding: EdgeInsets.all(5),
              ),
              badgeContent: Text('3'),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.primary,
                  size: getSize(30),
                ),
              ),
            )
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Icons.wb_sunny_rounded),
          ),
        ] : [],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            //TODO: put the nike logo image
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.deepPurpleAccent,
                child: Center(
                  child: Image.asset(
                    AssetsConstants.nikeLoo,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(
                              context,
                            RouteName.navigation,
                            arguments: 0
                          );
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.home,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            "Voir shop",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          "A propos",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  //TODO: put logout
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          RouteName.adminIntroPage
                      );
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      title: Text(
                        "Se déconnecter",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminGoogleNavBar(
        selectedIndex: widget.selectedIndex,
        onTabChange: (index) => onTabChange(index),
      ),
      body: _pages[widget.selectedIndex],
    );
  }
}
