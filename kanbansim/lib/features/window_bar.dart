import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class WindowBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 20,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: MoveWindow(),
                  ),
                  _windowButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _windowButtons extends StatelessWidget {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: _getMinimizeButtonColors(context).mouseOver,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: RawMaterialButton(
                shape: CircleBorder(),
                child: Icon(
                  Icons.minimize,
                  color: Colors.black,
                  size: 13,
                ),
                focusColor: Colors.white,
                onPressed: () => MinimizeWindowButton().onPressed(),
              ),
            ),
            SizedBox(width: 2),
            Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: _getMaximizeButtonColors(context).mouseOver,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: RawMaterialButton(
                shape: CircleBorder(),
                child: Icon(
                  Icons.crop_square,
                  color: Colors.black,
                  size: 13,
                ),
                focusColor: Colors.white,
                onPressed: () => MaximizeWindowButton().onPressed(),
              ),
            ),
            SizedBox(width: 2),
            Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: _getCloseButtonColors(context).mouseOver,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: RawMaterialButton(
                shape: CircleBorder(),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 13,
                ),
                focusColor: Colors.white,
                onPressed: () => CloseWindowButton().onPressed(),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ],
    );
  }
}
