import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import '/models/message_model.dart';
import '/models/post_model.dart';
import '/models/user_model.dart';
import '/modules/new_post/new_post.dart';
import '/modules/chat/chat_screen.dart';
import '/modules/feeds/feeds_screen.dart';
import '/modules/setting/setting_screen.dart';
import '/modules/users/users_screen.dart';
import '/shared/components/constants.dart';
import './app_states.dart';
// import '/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  late UserModel model;

  void getUserData() {
    emit(AppGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      model = UserModel.fromJson(value.data());
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppGetUserErrorState(error.toString()));
    });
  }

  // bool isDark = false;

  // void changeAppMode({fromShared}) {
  //   if (fromShared != null) {
  //     isDark = fromShared;
  //     emit(AppChangeModeState());
  //   } else {
  //     isDark = !isDark;
  //     CacheHelper.putBool(key: 'isDark', value: isDark).then(
  //       (value) => emit(AppChangeModeState()),
  //     );
  //   }
  // }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 2)
      emit(AppNewPostState());
    else {
      currentIndex = index;
      emit(AppChangeBottomNavState());
    }
  }

  File? profileImage;
  final picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(AppProfileImagePickedErrorState());
    }
  }

  File? coverImage;

  Future getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppCoverImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(AppCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(AppUpdateProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AppUpdateProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(AppUpdateCoverImageErrorState());
      });
    }).catchError((error) {
      emit(AppUpdateCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }) {
    UserModel uModel = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: model.email,
      image: image ?? model.image,
      cover: cover ?? model.cover,
      uId: model.uId,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .update(uModel.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(AppUserUpdateErrorState());
    });
  }

  File? postImage;

  Future getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(AppPostImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(AppPostImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(AppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        emit(AppCreatePostSuccessState());
      }).catchError((error) {
        emit(AppCreatePostErrorState());
      });
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage == null;
    emit(AppRemovePostImageState());
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    PostModel uModel = PostModel(
      name: model.name,
      image: model.image,
      uId: model.uId,
      dateTime: dateTime,
      postImage: postImage ?? '',
      text: text,
    );
    emit(AppCreatePostLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .add(uModel.toMap())
        .then((value) {
      emit(AppCreatePostSuccessState());
    }).catchError((error) {
      emit(AppCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];

  List<String> postsId = [];

  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(AppGetPostSuccessState());
    }).catchError((error) {
      emit(AppGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(AppLikePostSuccessState());
    }).catchError((error) {
      emit(AppLikePostErrorState(error.toString()));
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != model.uId)
            users.add(UserModel.fromJson(element.data()));
        });
        emit(AppGetAllUsersSuccessState());
      }).catchError((error) {
        emit(AppGetAllUsersErrorState(error.toString()));
      });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel mModel = MessageModel(
      senderId: model.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    // set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(mModel.toMap())
        .then((value) {
      emit(AppSendMessageSuceessState());
      ;
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
    // set receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model.uId)
        .collection('messages')
        .add(mModel.toMap())
        .then((value) {
      emit(AppSendMessageSuceessState());
      ;
    }).catchError((error) {
      emit(AppSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(AppGetMessageSuceessState());
    });
  }
}
