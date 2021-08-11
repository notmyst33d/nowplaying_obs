import 'package:flutter/material.dart';

import 'main.dart';

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
          color: widget.state.globalColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.state.popupPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.state.textSize,
                ),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: widget.state.textSize + 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.state.currentSong,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: widget.state.textSize,
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 4,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
