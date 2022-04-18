import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{

  static const loginCheck = "isLoggedIn";

  static  SharedPreferences? sharedPreferences;

  static Future init()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  

}