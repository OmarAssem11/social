import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/shared/styles/icon_broken.dart';

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

Widget defaultFormField({
  bool isPassword = false,
  bool isClickable = true,
  bool noKeyboard = false,
  IconData? suffix,
  Function? onChange,
  Function? onSubmit,
  Function? onTap,
  Function? suffixPressed,
  required Function validate,
  required String label,
  required IconData prefix,
  required TextInputType type,
  required TextEditingController controller,
}) {
  return TextFormField(
    readOnly: noKeyboard,
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit as void Function(String)?,
    onChanged: onChange as void Function(String)?,
    onTap: onTap as void Function()?,
    enabled: isClickable,
    validator: (s) {
      return validate(s);
    },
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(
              onPressed: suffixPressed! as void Function(),
              icon: Icon(suffix),
            )
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3,
  required Function function,
  required String text,
}) {
  return Container(
    width: width,
    height: 40,
    child: MaterialButton(
      onPressed: function as void Function()?,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(color: Colors.white),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: background,
    ),
  );
}

Widget defaultTextButton({
  required Function function,
  required String text,
}) {
  return TextButton(
    onPressed: function as void Function(),
    child: Text(text.toUpperCase()),
  );
}

void showToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

PreferredSizeWidget? defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
}) =>
    AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(IconBroken.Arrow___Left_2),
      ),
      title: Text(title),
      titleSpacing: 5,
      actions: actions,
    );

Widget myDivider() {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 18),
    child: Container(
      width: double.infinity,
      height: 0.5,
      color: Colors.grey,
    ),
  );
}
