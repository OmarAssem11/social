import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/modules/new_post/new_post.dart';
import '/shared/components/components.dart';
import '/shared/styles/icon_broken.dart';
import '/shared/cubit/app_cubit.dart';
import '/shared/cubit/app_states.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is AppNewPostState) navigateTo(context, NewPostScreen());
    }, builder: (context, state) {
      var cubit = AppCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(cubit.titles[cubit.currentIndex]),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(IconBroken.Notification),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(IconBroken.Search),
            ),
          ],
        ),
        body: cubit.screens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(IconBroken.Home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconBroken.Chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconBroken.Paper_Upload),
              label: 'Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconBroken.Location),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconBroken.Setting),
              label: 'Settings',
            ),
          ],
          currentIndex: cubit.currentIndex,
          onTap: (index) {
            cubit.changeBottomNav(index);
          },
        ),
      );
    });
  }
}
