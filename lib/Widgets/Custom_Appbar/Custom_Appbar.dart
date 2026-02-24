import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? appbarTitle;
  final bool? appbarcenterTitle;
  final List<Widget>? actions;

  const CustomAppbar({
    required this.appbarTitle,
    this.appbarcenterTitle,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(appbarTitle ?? "",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: appbarcenterTitle ?? false,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF9D5E5), Color(0xffB8A9D9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
