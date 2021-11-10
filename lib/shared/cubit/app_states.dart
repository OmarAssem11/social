abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserLoadingState extends AppStates {}

class AppGetUserSuccessState extends AppStates {}

class AppGetUserErrorState extends AppStates {
  final String error;
  AppGetUserErrorState(this.error);
}

class AppGetAllUsersLoadingState extends AppStates {}

class AppGetAllUsersSuccessState extends AppStates {}

class AppGetAllUsersErrorState extends AppStates {
  final String error;
  AppGetAllUsersErrorState(this.error);
}

class AppGetPostLoadingState extends AppStates {}

class AppGetPostSuccessState extends AppStates {}

class AppGetPostErrorState extends AppStates {
  final String error;
  AppGetPostErrorState(this.error);
}

class AppLikePostSuccessState extends AppStates {}

class AppLikePostErrorState extends AppStates {
  final String error;
  AppLikePostErrorState(this.error);
}

class AppChangeBottomNavState extends AppStates {}

class AppNewPostState extends AppStates {}

// Edit Profile

class AppProfileImagePickedSuccessState extends AppStates {}

class AppProfileImagePickedErrorState extends AppStates {}

class AppCoverImagePickedSuccessState extends AppStates {}

class AppCoverImagePickedErrorState extends AppStates {}

class AppUpdateProfileImageSuccessState extends AppStates {}

class AppUpdateProfileImageErrorState extends AppStates {}

class AppUpdateCoverImageSuccessState extends AppStates {}

class AppUpdateCoverImageErrorState extends AppStates {}

class AppUserUpdateLoadingState extends AppStates {}

class AppUserUpdateErrorState extends AppStates {}

// Create Post

class AppCreatePostLoadingState extends AppStates {}

class AppCreatePostSuccessState extends AppStates {}

class AppCreatePostErrorState extends AppStates {}

class AppPostImagePickedSuccessState extends AppStates {}

class AppPostImagePickedErrorState extends AppStates {}

class AppRemovePostImageState extends AppStates {}

// Chat

class AppSendMessageSuceessState extends AppStates {}

class AppSendMessageErrorState extends AppStates {}

class AppGetMessageSuceessState extends AppStates {}

//class AppChangeModeState extends AppStates {}