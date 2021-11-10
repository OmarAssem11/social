import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '/shared/components/components.dart';
import '/shared/cubit/app_cubit.dart';
import '/shared/cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Verification'),
            ),
            body: ConditionalBuilder(
              // ignore: unnecessary_null_comparison
              condition: AppCubit.get(context).model != null,
              builder: (context) {
                return Column(
                  children: [
                    if (!FirebaseAuth.instance.currentUser!.emailVerified)
                      Container(
                        color: Colors.amber.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text('Please send email verification'),
                              ),
                              SizedBox(width: 15),
                              defaultTextButton(
                                function: () {
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification()
                                      .then((value) {
                                    showToast(
                                      text: 'Check your email',
                                      state: ToastStates.SUCCESS,
                                    );
                                  }).catchError((error) {});
                                },
                                text: 'send',
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        });
  }
}
