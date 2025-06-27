import 'package:flutter/material.dart';
import 'package:shop_online/themes/themes.dart';
import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  void setThemeData(ThemeData themeData){
    _themeData = darkMode;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeData == lightMode){
      _themeData = darkMode;
    }else{
      _themeData = lightMode;
    }
    notifyListeners();
  }

   static ThemeProvider of(BuildContext context, {bool listen = true}){
    return Provider.of<ThemeProvider>(context, listen : listen);
  }

  //ne marche pas
  bool isLightTheme(){
    if(_themeData == lightMode){
      return true;
    }
    return false;
  }

}