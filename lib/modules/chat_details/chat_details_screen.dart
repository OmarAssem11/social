import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '/models/message_model.dart';
import '/shared/cubit/app_cubit.dart';
import '/shared/cubit/app_states.dart';
import '/shared/styles/colors.dart';
import '/shared/styles/icon_broken.dart';
import '/models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel model;
  ChatDetailsScreen(this.model);
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = AppCubit.get(context);
    return Builder(builder: (context) {
      cubit.getMessages(receiverId: model.uId);
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(model.image),
                  ),
                  SizedBox(width: 15),
                  Text(model.name),
                ],
              ),
            ),
            body: ConditionalBuilder(
              condition: cubit.messages.length > 0,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final message = cubit.messages[index];
                          if (cubit.model.uId == message.senderId)
                            return buildMyMessage(message);
                          else
                            return buildMessage(message);
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 15),
                        itemCount: cubit.messages.length,
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type your message here ...',
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            color: defaultColor,
                            child: MaterialButton(
                              onPressed: () {
                                cubit.sendMessage(
                                  receiverId: model.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                                messageController.clear();
                              },
                              minWidth: 1,
                              child: Icon(
                                IconBroken.Send,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
          );
        },
      );
    });
  }

  Widget buildMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(message.text),
        ),
      );

  Widget buildMyMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(.3),
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10),
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(message.text),
        ),
      );
}
