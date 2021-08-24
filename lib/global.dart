import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget ingenieriaTextfield(
    {Widget prefixIcon,
    Function(String) onChanged,
    List<TextInputFormatter> inputFormatters,
    String hintText,
    Function onTap,
    TextEditingController controller,
    int maxLines,
    TextInputAction textInputAction,
    TextInputType keyboardType}) {
  return TextField(
    controller: controller,
    textInputAction: textInputAction,
    onTap: onTap,
    inputFormatters: inputFormatters,
    maxLines: maxLines,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      hintText: hintText,
      filled: true,
      contentPadding: EdgeInsets.only(top: 30.0, left: 10.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(8.0),
      ),
      fillColor: Colors.grey[200],
    ),
  );
}


class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}