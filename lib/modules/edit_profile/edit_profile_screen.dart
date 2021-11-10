import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/styles/icon_broken.dart';
import '/shared/cubit/app_cubit.dart';
import '/shared/cubit/app_states.dart';
import '/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).model;
        var profileImage = AppCubit.get(context).profileImage;
        var coverImage = AppCubit.get(context).coverImage;
        nameController.text = userModel.name;
        bioController.text = userModel.bio;
        phoneController.text = userModel.phone;
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                function: () {
                  AppCubit.get(context).updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                text: 'Update',
              ),
              SizedBox(width: 15),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  if (state is AppUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if (state is AppUserUpdateLoadingState) SizedBox(height: 10),
                  Container(
                    height: 190,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    topLeft: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                        : FileImage(coverImage)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    AppCubit.get(context).getCoverImage(),
                                icon: CircleAvatar(
                                  radius: 18,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  AppCubit.get(context).getProfileImage(),
                              icon: CircleAvatar(
                                radius: 18,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  if (AppCubit.get(context).profileImage != null ||
                      AppCubit.get(context).profileImage != null)
                    Row(
                      children: [
                        if (AppCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    AppCubit.get(context).uploadProfileImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text);
                                  },
                                  text: 'Upload profile',
                                ),
                                if (state is AppUserUpdateLoadingState)
                                  SizedBox(height: 5),
                                if (state is AppUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(width: 5),
                        if (AppCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  function: () {
                                    AppCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text);
                                  },
                                  text: 'Upload cover',
                                ),
                                if (state is AppUserUpdateLoadingState)
                                  SizedBox(height: 5),
                                if (state is AppUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: 20),
                  defaultFormField(
                    validate: (String value) {
                      if (value.isEmpty) return 'Name must not be empty';
                    },
                    label: 'Name',
                    prefix: IconBroken.User,
                    type: TextInputType.name,
                    controller: nameController,
                  ),
                  SizedBox(height: 10),
                  defaultFormField(
                    validate: (String value) {
                      if (value.isEmpty) return 'Bio must not be empty';
                    },
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
                    type: TextInputType.text,
                    controller: bioController,
                  ),
                  SizedBox(height: 10),
                  defaultFormField(
                    validate: (String value) {
                      if (value.isEmpty)
                        return 'Phone number must not be empty';
                    },
                    label: 'Phone number',
                    prefix: IconBroken.Call,
                    type: TextInputType.phone,
                    controller: phoneController,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
