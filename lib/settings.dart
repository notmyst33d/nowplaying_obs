import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';
import 'slide_popup.dart';
import 'window_popup.dart';
import 'extensions.dart';

class Settings extends StatefulWidget {
  final Function(double) onWidthFactorChanged;
  final Function(int, bool) onStyleCardHoverChanged;
  final Function(String) onStyleChanged;
  final Function(Color) onColorChanged;
  final Function(double) onTextSizeChanged;
  final Function(double) onPopupPaddingChanged;
  final Function(double) onAnimationMillisecondsChanged;
  final Function(double) onAnimationHoldMillisecondsChanged;
  final Color color;
  final NowPlayingState state;

  Settings(
      {Key? key,
      required this.onWidthFactorChanged,
      required this.onStyleCardHoverChanged,
      required this.onStyleChanged,
      required this.onColorChanged,
      required this.onTextSizeChanged,
      required this.onPopupPaddingChanged,
      required this.onAnimationMillisecondsChanged,
      required this.onAnimationHoldMillisecondsChanged,
      required this.color,
      required this.state})
      : super(key: key);

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final textController = TextEditingController();
  bool appliedVisible = false;

  var timer;

  void playAppliedAnimation() {
    timer?.cancel();

    setState(() {
      appliedVisible = true;
    });

    timer = Timer(Duration(seconds: 1), () {
      setState(() {
        appliedVisible = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    textController.text = widget.state.globalColor.toHex();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SettingsElement(),
                Padding(padding: EdgeInsets.all(8)),
                StyleElement(),
                StyleElementContent(),
                Padding(padding: EdgeInsets.all(8)),
                ConfigurationElement(),
                ConfigurationElementContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget SettingsElement() {
    return Row(
      children: [
        Icon(
          Icons.settings_outlined,
          size: 48,
          color: widget.state.globalColor,
        ),
        Padding(padding: EdgeInsets.all(6)),
        Text(
          'Settings',
          style: TextStyle(fontSize: 24),
        ),
        Spacer(),
        AnimatedOpacity(
          opacity: appliedVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: Text('Style applied'),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_outlined),
        )
      ],
    );
  }

  Widget StyleElement() {
    return Row(
      children: [
        Icon(
          Icons.style_outlined,
          size: 32,
          color: widget.state.globalColor,
        ),
        Padding(padding: EdgeInsets.all(4)),
        Text(
          'Style',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget StyleElementContent() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            Tooltip(
              message: 'Slide',
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.onStyleChanged('SlidePopup');
                    playAppliedAnimation();
                  });
                },
                child: MouseRegion(
                  onHover: (event) {
                    setState(() {
                      widget.onStyleCardHoverChanged(0, true);
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      widget.onStyleCardHoverChanged(0, false);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding:
                        EdgeInsets.all(widget.state.styleCardHover[0] ? 8 : 0),
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: SlidePopup(state: widget.state),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Tooltip(
              message: 'Window',
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.onStyleChanged('WindowPopup');
                    playAppliedAnimation();
                  });
                },
                child: MouseRegion(
                  onHover: (event) {
                    setState(() {
                      widget.onStyleCardHoverChanged(1, true);
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      widget.onStyleCardHoverChanged(1, false);
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding:
                        EdgeInsets.all(widget.state.styleCardHover[1] ? 8 : 0),
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: WindowPopup(state: widget.state),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ConfigurationElement() {
    return Row(
      children: [
        Icon(
          Icons.tune_outlined,
          size: 32,
          color: widget.state.globalColor,
        ),
        Padding(padding: EdgeInsets.all(4)),
        Text(
          'Configuration',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget ConfigurationElementContent() {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popup width'),
          Slider(
            value: widget.state.widthFactor,
            min: 0.1,
            max: 1.0,
            divisions: 20,
            label: widget.state.widthFactor.toString(),
            activeColor: widget.state.globalColor,
            onChanged: (value) {
              setState(() {
                widget.onWidthFactorChanged(
                    double.parse(value.toStringAsPrecision(2)));
              });
            },
          ),
          Text('Popup padding'),
          Slider(
            value: widget.state.popupPadding,
            min: 4,
            max: 48,
            divisions: 20,
            label: widget.state.popupPadding.toInt().toString(),
            activeColor: widget.state.globalColor,
            onChanged: (value) {
              setState(() {
                widget.onPopupPaddingChanged(
                    double.parse(value.toInt().toString()));
              });
            },
          ),
          Text('Animation speed in seconds'),
          Slider(
            value: widget.state.animationMilliseconds.toDouble(),
            min: 200,
            max: 3000,
            divisions: 20,
            label: (widget.state.animationMilliseconds / 1000).toString(),
            activeColor: widget.state.globalColor,
            onChanged: (value) {
              setState(() {
                widget.onAnimationMillisecondsChanged(
                    double.parse(value.toInt().toString()));
              });
            },
          ),
          Text('Animation hold speed in seconds'),
          Slider(
            value: widget.state.animationHoldMilliseconds.toDouble(),
            min: 200,
            max: 10000,
            divisions: 20,
            label: (widget.state.animationHoldMilliseconds / 1000).toString(),
            activeColor: widget.state.globalColor,
            onChanged: (value) {
              setState(() {
                widget.onAnimationHoldMillisecondsChanged(
                    double.parse(value.toInt().toString()));
              });
            },
          ),
          Padding(padding: EdgeInsets.all(4)),
          Text('Text size'),
          Slider(
            value: widget.state.textSize,
            min: 14,
            max: 56,
            divisions: 20,
            label: widget.state.textSize.toInt().toString(),
            activeColor: widget.state.globalColor,
            onChanged: (value) {
              setState(() {
                widget
                    .onTextSizeChanged(double.parse(value.toInt().toString()));
              });
            },
          ),
          Text('Color'),
          Padding(padding: EdgeInsets.all(4)),
          TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: widget.state.globalColor, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              hintText: widget.state.globalColor.toHex(),
            ),
            cursorColor: widget.state.globalColor,
            controller: textController,
            onChanged: (value) {
              try {
                if (textController.text.length == 7) {
                  final newColor = HexColor.fromHex(textController.text);
                  setState(() {
                    widget.onColorChanged(newColor);
                  });
                }
              } catch (e) {}
            },
          )
        ],
      ),
    );
  }
}
