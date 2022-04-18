import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zartek_test/src/services/shared_preference_helper.dart';
import 'package:zartek_test/src/view/auth_screen/auth_screen.dart';
import 'package:zartek_test/src/view/dish_cart/dish_cart_screen.dart';
import 'package:zartek_test/src/view/user_home_screen/user_home_screen.dart';
import 'package:zartek_test/src/view_model/auth_provider.dart';
import 'package:zartek_test/src/view_model/restaurant_provider.dart';
import 'package:zartek_test/src/view_model/user_data_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await SharedPreferenceHelper.init();
  runApp(MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => RestaurantDataProvider()),
          ChangeNotifierProvider(create: (_) => UserDataProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          '/': (_) => AuthMainScreen(),
          UserHomeScreen.route: (_) => UserHomeScreen(),
          DishCartScreen.route:(_)  => DishCartScreen()
        },
        title: 'Zartek Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
