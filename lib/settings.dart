import 'dart:async';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'main.dart';
import 'slide_popup.dart';
import 'window_popup.dart';
import 'extensions.dart';
import 'color_utils.dart';

class Settings extends StatefulWidget {
  final Function(double) onWidthFactorChanged;
  final Function(int, bool) onStyleCardHoverChanged;
  final Function(String) onStyleChanged;
  final Function(Color) onColorChanged;
  final Function(double) onTextSizeChanged;
  final Function(double) onPopupPaddingChanged;
  final Function(double) onAnimationSecondsChanged;
  final Function(double) onAnimationHoldSecondsChanged;
  final Function(bool) onDarkModeChanged;
  final NowPlayingState state;

  Settings({
    Key? key,
    required this.onWidthFactorChanged,
    required this.onStyleCardHoverChanged,
    required this.onStyleChanged,
    required this.onColorChanged,
    required this.onTextSizeChanged,
    required this.onPopupPaddingChanged,
    required this.onAnimationSecondsChanged,
    required this.onAnimationHoldSecondsChanged,
    required this.onDarkModeChanged,
    required this.state,
  }) : super(key: key);

  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final textController = TextEditingController();
  var appliedVisible = false;
  var timer;
  var package = PackageInfo(
    appName: 'Loading...',
    packageName: 'Loading...',
    version: 'Loading...',
    buildNumber: 'Loading...',
    buildSignature: 'Loading...',
  );

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

    PackageInfo.fromPlatform().then((info) {
      setState(() {
        package = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.state.darkMode
              ? getDarkColor(widget.state.globalColor)
              : getLightColor(widget.state.globalColor),
        ),
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

  SliderTheme MaterialYouSlider({required Slider child}) {
    return SliderTheme(
      data: SliderThemeData(
        inactiveTrackColor: widget.state.darkMode
            ? getLightColor(widget.state.globalColor)
            : getDarkColor(widget.state.globalColor),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: child,
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
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.state.globalColor,
          ),
        ),
        Spacer(),
        AnimatedOpacity(
          opacity: appliedVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: Text(
            'Style applied',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
        ),
        Spacer(),
        Switch(
          value: widget.state.darkMode,
          thumbColor: MaterialStateProperty.all(widget.state.globalColor),
          trackColor: MaterialStateProperty.all(widget.state.darkMode
              ? getLightColor(widget.state.globalColor)
              : getDarkColor(widget.state.globalColor)),
          onChanged: (value) {
            setState(() {
              widget.onDarkModeChanged(value);
            });
          },
        ),
        Text(
          'Dark mode',
          style: TextStyle(
            color: widget.state.globalColor,
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 24)),
        IconButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => InfoDialog(context));
          },
          icon: Icon(
            Icons.info_outlined,
            color: widget.state.globalColor,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close_outlined,
            color: widget.state.globalColor,
          ),
        ),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.state.globalColor,
          ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: widget.state.darkMode
                          ? getLightColor(widget.state.globalColor)
                          : getDarkColor(widget.state.globalColor),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: widget.state.darkMode
                          ? getLightColor(widget.state.globalColor)
                          : getDarkColor(widget.state.globalColor),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.state.globalColor,
          ),
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
          Text(
            'Popup width',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
          MaterialYouSlider(
            child: Slider(
              value: widget.state.widthFactor,
              min: 0.1,
              max: 1.0,
              label: widget.state.widthFactor.toString(),
              activeColor: widget.state.globalColor,
              onChanged: (value) {
                setState(() {
                  widget.onWidthFactorChanged(
                      double.parse(value.toStringAsPrecision(2)));
                });
              },
            ),
          ),
          Text(
            'Popup padding',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
          MaterialYouSlider(
            child: Slider(
              value: widget.state.popupPadding,
              min: 4,
              max: 48,
              label: widget.state.popupPadding.toInt().toString(),
              activeColor: widget.state.globalColor,
              onChanged: (value) {
                setState(() {
                  widget.onPopupPaddingChanged(
                      double.parse(value.toInt().toString()));
                });
              },
            ),
          ),
          Text(
            'Animation speed in seconds',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
          MaterialYouSlider(
            child: Slider(
              value: widget.state.animationSeconds,
              min: 0.2,
              max: 10,
              label: widget.state.animationSeconds.toString(),
              activeColor: widget.state.globalColor,
              onChanged: (value) {
                setState(() {
                  widget.onAnimationSecondsChanged(
                      double.parse(value.toStringAsFixed(1)));
                });
              },
            ),
          ),
          Text(
            'Animation hold speed in seconds',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
          MaterialYouSlider(
            child: Slider(
              value: widget.state.animationHoldSeconds,
              min: 0.2,
              max: 10,
              label: widget.state.animationHoldSeconds.toString(),
              activeColor: widget.state.globalColor,
              onChanged: (value) {
                setState(() {
                  widget.onAnimationHoldSecondsChanged(
                      double.parse(value.toStringAsFixed(1)));
                });
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(4)),
          Text(
            'Text size',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
          MaterialYouSlider(
            child: Slider(
              value: widget.state.textSize,
              min: 14,
              max: 56,
              label: widget.state.textSize.toInt().toString(),
              activeColor: widget.state.globalColor,
              onChanged: (value) {
                setState(() {
                  widget.onTextSizeChanged(
                      double.parse(value.toInt().toString()));
                });
              },
            ),
          ),
          Text(
            'Color',
            style: TextStyle(
              color: widget.state.globalColor,
            ),
          ),
          Padding(padding: EdgeInsets.all(4)),
          TextField(
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.state.globalColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.state.globalColor,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              hintText: widget.state.globalColor.toHex(),
            ),
            cursorColor: widget.state.globalColor,
            controller: textController,
            style: TextStyle(
              color: widget.state.globalColor,
            ),
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
          ),
        ],
      ),
    );
  }

  Widget InfoDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.state.darkMode
              ? getDarkColor(widget.state.globalColor)
              : getLightColor(widget.state.globalColor),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InfoElement(),
                InfoElementContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget InfoElement() {
    return Row(
      children: [
        Icon(
          Icons.info_outlined,
          size: 48,
          color: widget.state.globalColor,
        ),
        Padding(padding: EdgeInsets.all(6)),
        Text(
          'Info',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.state.globalColor,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close_outlined,
            color: widget.state.globalColor,
          ),
        ),
      ],
    );
  }

  Widget InfoElementContent() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 32)),
        Image.asset("assets/icon.png", height: 72, width: 72),
        Padding(padding: EdgeInsets.only(top: 16)),
        Text(
          'Now Playing OBS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: widget.state.globalColor,
          ),
        ),
        Text(
          'Version ${package.version}',
          style: TextStyle(
            fontSize: 20,
            color: widget.state.globalColor,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 32)),
        Text(
          'Source code: https://github.com/notmyst33d/nowplaying_obs',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.state.globalColor,
          ),
        ),
      ],
    );
  }
}
