import 'package:flutter/material.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class ScrollBar extends StatefulWidget {
  Widget child;

  ScrollBar({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScrollBarState();
}

class ScrollBarState extends State<ScrollBar> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return VsScrollbar(
      controller: _scrollController,
      showTrackOnHover: true,
      isAlwaysShown: true,
      scrollbarFadeDuration: Duration(milliseconds: 500),
      scrollbarTimeToFade: Duration(milliseconds: 800),
      style: VsScrollbarStyle(
        hoverThickness: 15.0,
        radius: Radius.circular(15),
        thickness: 15.0,
        color: Theme.of(context).primaryColor,
      ),
      child: ListView(
        padding: EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
        ),
        controller:
            _scrollController, // use same scrollController object to support drag functionality
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          this.widget.child,
        ],
      ),
    );
  }
}
