import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '/shared/components/components.dart';
import '/modules/register/cubit/register_cubit.dart';
import '/modules/register/cubit/register_states.dart';
import '/layout/social_layout.dart';
//import '/layout/home_layout.dart';

class RegisterScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
        if (state is CreateUserSuccessState) {
          navigateAndFinish(
            context,
            //HomeLayout(),
            SocialLayout(),
          );
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REGISTER',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Register now to communicate with friends',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 30),
                      defaultFormField(
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                        },
                        label: 'User name',
                        prefix: Icons.person,
                        type: TextInputType.name,
                        controller: nameController,
                      ),
                      SizedBox(height: 15),
                      defaultFormField(
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email address';
                          }
                        },
                        label: 'Email address',
                        prefix: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                      SizedBox(height: 15),
                      defaultFormField(
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Password is too short';
                          }
                        },
                        label: 'Password',
                        prefix: Icons.lock_outline,
                        type: TextInputType.visiblePassword,
                        controller: passwordController,
                        suffix: RegisterCubit.get(context).suffix,
                        suffixPressed: () {
                          RegisterCubit.get(context).changePasswordVisibility();
                        },
                        onSubmit: (value) {},
                        isPassword: RegisterCubit.get(context).isPassword,
                      ),
                      SizedBox(height: 15),
                      defaultFormField(
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                        },
                        label: 'Phone number',
                        prefix: Icons.phone,
                        type: TextInputType.phone,
                        controller: phoneController,
                      ),
                      SizedBox(height: 30),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text,
                              );
                            }
                          },
                          text: 'register',
                          isUpperCase: true,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
