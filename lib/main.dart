import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'modules/login/login_screen.dart';
import 'shared/cubit/bloc_observer.dart';
import 'shared/styles/themes.dart';
import 'shared/cubit/app_cubit.dart';
import 'shared/cubit/app_states.dart';
// import 'shared/network/local/cache_helper.dart';
// import 'shared/components/components.dart';
// import 'modules/login/login_screen.dart';
// import 'layout/social_layout.dart';
// import 'layout/home_layout.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   showToast(
//     text: 'on background message',
//     state: ToastStates.SUCCESS,
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // final token = await FirebaseMessaging.instance.getToken();
  // FirebaseMessaging.onMessage.listen((event) {
  //   showToast(
  //     text: 'on message',
  //     state: ToastStates.SUCCESS,
  //   );
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //   showToast(
  //     text: 'on message opened app',
  //     state: ToastStates.SUCCESS,
  //   );
  // });
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();

  // await CacheHelper.init;

  // Widget? startWidget;
  //bool? isDark = false;
  //= CacheHelper.getData(key: 'isDark');
  // dynamic uId = CacheHelper.getData(key: 'uId');

  // if (uId != null)
  //   startWidget = HomeLayout();
  // else
  //   startWidget = LoginScreen();

  runApp(MyApp(
      //dark: isDark,
      // start: startWidget,
      ));
}

class MyApp extends StatelessWidget {
  //final bool? dark;
  // final Widget? start;

  MyApp(
      //{required this.dark,
      //required this.start,}
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getUserData()
        ..getPosts(),
      //..changeAppMode(fromShared: dark),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            //var cubit = AppCubit.get(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              // darkTheme: darkTheme,
              //themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
              home: LoginScreen(),
            );
          }),
    );
  }
}
