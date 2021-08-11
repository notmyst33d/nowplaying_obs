import 'package:flutter/material.dart';

import 'main.dart';

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
      decoration: BoxDecoration(color: widget.state.globalColor),
      child: Padding(
        padding: EdgeInsets.all(widget.state.popupPadding),
        child: Row(
          children: [
            Icon(
              Icons.music_note,
              color: Colors.white,
              size: widget.state.textSize + 10,
            ),
            Expanded(
              child: Text(
                widget.state.currentSong,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.state.textSize,
                ),
              ),
            ),
            Text(
              'Now Playing',
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.state.textSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
