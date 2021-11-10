import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/styles/icon_broken.dart';
import '/shared/cubit/app_cubit.dart';
import '/shared/cubit/app_states.dart';
import '/shared/components/components.dart';

class NewPostScreen extends StatelessWidget {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Create Post',
            actions: [
              defaultTextButton(
                function: () {
                  if (cubit.postImage == null)
                    cubit.createPost(
                      dateTime: DateTime.now().toString(),
                      text: textController.text,
                    );
                  else
                    cubit.uploadPostImage(
                      dateTime: DateTime.now().toString(),
                      text: textController.text,
                    );
                },
                text: 'post',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (state is AppCreatePostLoadingState)
                  LinearProgressIndicator(),
                if (state is AppCreatePostLoadingState) SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(cubit.model.image),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        cubit.model.name,
                        style: TextStyle(
                          height: 1.3,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (cubit.postImage != null &&
                    state is! AppRemovePostImageState)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cubit.removePostImage(),
                        icon: CircleAvatar(
                          radius: 18,
                          child: Icon(
                            Icons.close,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            SizedBox(width: 5),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('Tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
