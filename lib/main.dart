import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';
import 'package:shop_online/providers/favorite_provider.dart';
import 'package:shop_online/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'services/auth_service.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  
  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);
    return Consumer<ThemeProvider>(
      builder:
          (context, themeProvider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Provider.of<ThemeProvider>(context).themeData,
            initialRoute: RouteName.adminIntroPage,
            onGenerateRoute: Routes.onGenerateRoute,
          ),
    );
  }
}
