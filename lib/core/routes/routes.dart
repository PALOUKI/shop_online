import 'package:flutter/material.dart';
import 'package:shop_online/core/routes/routes_names.dart';
import 'package:shop_online/models/Product.dart';
import 'package:shop_online/pages/detail_page.dart';
import 'package:shop_online/pages/home_page.dart';
import 'package:shop_online/pages/category_page.dart';
import 'package:shop_online/pages/see_all_products.dart';

import '../../admin/pages/admin_intro_page.dart';
import '../../admin/pages/admin_login.dart';
import '../../admin/widgets/admin_navigation.dart';
import '../../models/Category.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/auth/signup_page.dart';
import '../../pages/cart_page.dart';
import '../../pages/intro_page.dart';
import '../../pages/profile/sections/edit_profile_page.dart';
import '../../pages/profile/profile_page.dart';
import '../../pages/profile/sections/order_page.dart';
import '../../widgets/navigation.dart';



class Routes{

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings){

    switch(routeSettings.name){
      case RouteName.introPage:
        return MaterialPageRoute(builder: (_) => const IntroPage());

      case RouteName.navigation:
        final int selectedIndex = routeSettings.arguments as int;
        return MaterialPageRoute(builder: (_) =>  Navigation(selectedIndex: selectedIndex,));

      case RouteName.cartPage:
        return MaterialPageRoute(builder: (_) => const CartPage());

      case RouteName.categoryPage:
        final category = routeSettings.arguments as Category;
        return MaterialPageRoute(
          builder: (_) => CategoryPage(
            category: category,
          ),
        );

      case RouteName.detailPage:
        final product = routeSettings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => DetailPage(
            product: product,
          ),
        );

      case RouteName.seeAllProducts:
        return MaterialPageRoute(builder: (_) => const SeeAllProducts());
      
      // Auth routes
      case RouteName.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteName.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case RouteName.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case RouteName.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());
      case RouteName.orderPage:
        return MaterialPageRoute(builder: (_) => const OrderPage());

      
      // Admin routes
      case RouteName.adminNavigation:
        final int selectedIndex = routeSettings.arguments as int;
        return MaterialPageRoute(builder: (_) =>  AdminNavigation(selectedIndex: selectedIndex,));
      case RouteName.adminIntroPage:
        return MaterialPageRoute(builder: (_) => const AdminIntroPage());
      case RouteName.adminLogin:
        return MaterialPageRoute(builder: (_) => const AdminLogin());


      default:
        return MaterialPageRoute(builder: (_) => const
            Scaffold(
              body: Center(
                child: Text("Error route"),
              ),
            )
        );
    }
  }


}

