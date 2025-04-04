import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Widget? child;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final AlignmentGeometry alignment;
  final PreferredSizeWidget? appBar;

  const CustomWidget({
    super.key,
    this.child,
    this.backgroundColor,
    this.drawer,
    this.bottomNavigationBar,
    this.appBar,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Align(
          alignment: alignment,
          child: child,
        ),
      ),
    );
  }
}
