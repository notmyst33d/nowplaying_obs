import 'package:flutter/material.dart';

import 'main.dart';
import 'color_utils.dart';

class WindowPopup extends StatefulWidget {
  final NowPlayingState state;

  WindowPopup({
    Key? key,
    required this.state,
  }) : super(key: key);

  WindowPopupState createState() => WindowPopupState();
}

class WindowPopupState extends State<WindowPopup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        width: widget.state.popupWidth,
        decoration: BoxDecoration(
          color: widget.state.darkMode ? getDarkColor(widget.state.globalColor) : getLightColor(widget.state.globalColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.state.popupPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 8)),
              Padding(
                padding: EdgeInsets.only(left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.state.currentSong,
                        style: TextStyle(
                          color: widget.state.globalColor,
                          fontSize: widget.state.textSize,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
