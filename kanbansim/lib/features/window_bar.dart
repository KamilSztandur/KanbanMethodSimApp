import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 100,
            color: Colors.transparent,
            child: Column(children: [
              WindowTitleBarBox(
                  child: Row(children: [
                Expanded(child: MoveWindow()),
                _WindowButtons()
              ])),
            ])));
  }
}

class _WindowButtons extends StatelessWidget {
  WindowButtonColors _getMinimizeButtonColors(BuildContext context) {
    return WindowButtonColors(
      mouseOver: Colors.orangeAccent.shade200,
      mouseDown: Colors.black,
      iconNormal: Colors.white,
      iconMouseOver: Colors.deepOrange.shade900,
    );
  }

  WindowButtonColors _getMaximizeButtonColors(BuildContext context) {
    return WindowButtonColors(
      mouseOver: Colors.green,
      mouseDown: Colors.green,
      iconNormal: Colors.white,
      iconMouseOver: Colors.green.shade900,
    );
  }

  WindowButtonColors _getCloseButtonColors(BuildContext context) {
    return WindowButtonColors(
      mouseOver: Colors.redAccent,
      mouseDown: Colors.red,
      iconNormal: Colors.white,
      iconMouseOver: Colors.red.shade900,
    );
  }

  @override
  Widget build(BuildContext context) {
    WindowButtonColors minimizeButtonColors = _getMinimizeButtonColors(context);
    WindowButtonColors maximizeButtonColors = _getMaximizeButtonColors(context);
    WindowButtonColors closeButtonColors = _getCloseButtonColors(context);

    return Row(
      children: [
        MinimizeWindowButton(colors: minimizeButtonColors),
        MaximizeWindowButton(colors: maximizeButtonColors),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
