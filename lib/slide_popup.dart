import 'package:flutter/material.dart';

import 'main.dart';
import 'color_utils.dart';

class SlidePopup extends StatefulWidget {
  final NowPlayingState state;

  SlidePopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  SlidePopupState createState() => SlidePopupState();
}

class SlidePopupState extends State<SlidePopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.state.popupWidth,
      decoration: BoxDecoration(
        color: widget.state.darkMode
            ? getDarkColor(widget.state.globalColor)
            : getLightColor(widget.state.globalColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.state.popupPadding),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.state.currentSong,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: widget.state.globalColor,
                  fontSize: widget.state.textSize,
                ),
              ),
            ),
            Icon(
              Icons.music_note,
              color: widget.state.globalColor,
              size: widget.state.textSize + 8,
            ),
            Padding(padding: EdgeInsets.only(left: 4)),
            Text(
              'Now Playing',
              style: TextStyle(
                color: widget.state.globalColor,
                fontSize: widget.state.textSize + 4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
