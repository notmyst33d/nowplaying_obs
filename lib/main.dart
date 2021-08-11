import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'settings.dart';
import 'server.dart';
import 'slide_popup.dart';
import 'window_popup.dart';
import 'extensions.dart';

void main([List<String> args = const []]) {
  if (args.contains('server')) {
    runApp(NowPlayingServerApp());
  } else {
    runApp(NowPlayingApp());
  }
}

class NowPlayingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Now Playing OBS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green,
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: NowPlaying(),
    );
  }
}

class NowPlaying extends StatefulWidget {
  @override
  NowPlayingState createState() {
    final stateClass = NowPlayingState();
    stateClass.loadConfig();
    stateClass.setupServer();
    return stateClass;
  }
}

class NowPlayingState extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  late final router = shelf_router.Router()..post('/', onUpdate);
  late final cascade = Cascade().add(router);
  late final server;
  var timer;

  late final SharedPreferences storage;

  // Customizable variables
  Color globalColor = Colors.indigoAccent[100]!;
  double animationMilliseconds = 1000;
  double animationHoldMilliseconds = 3000;
  double widthFactor = 1;
  double textSize = 14;
  double popupPadding = 12;
  String popup = 'SlidePopup';
  // ----------------------

  double popupWidth = 0;
  List<bool> styleCardHover = [false, false];
  bool settingsButtonVisible = false;

  String currentSong = 'None';

  late final AnimationController controller = AnimationController(
    duration: Duration(milliseconds: animationMilliseconds.toInt()),
    vsync: this,
  );

  late final Animation<Offset> offset = Tween<Offset>(
    begin: Offset(1.0, 0.0),
    end: Offset(0.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    server.close();
  }

  void loadConfig() async {
    storage = await SharedPreferences.getInstance();
    globalColor = HexColor.fromHex(storage.getString('globalColor') ?? '#8c9eff');
    animationMilliseconds = storage.getDouble('animationMilliseconds') ?? 1000;
    animationHoldMilliseconds = storage.getDouble('animationHoldMilliseconds') ?? 3000;
    widthFactor = storage.getDouble('widthFactor') ?? 1;
    textSize = storage.getDouble('textSize') ?? 14;
    popupPadding = storage.getDouble('popupPadding') ?? 12;
    popup = storage.getString('popup') ?? 'SlidePopup';
  }

  Future setupServer() async {
    if (kIsWeb) {
      print('Running on web, going to poll external server');

      bool lock = false;
      final client = http.Client();

      Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (!lock) {
          lock = true;

          client
              .get(Uri.parse('http://127.0.0.1:50142/update'))
              .then((response) {
            if (response.body != currentSong) {
              setState(() {
                currentSong = response.body;
              });
              playAnimation();
            }

            lock = false;
          }).onError((error, stackTrace) {
            lock = false;
          });
        }
      });
    } else {
      server = await shelf_io.serve(
        logRequests().addHandler(cascade.handler),
        InternetAddress.anyIPv4,
        50142,
      );
    }
  }

  Response onUpdate(Request request) {
    request.readAsString().then((body) {
      final json = jsonDecode(body);
      setState(() {
        currentSong = '${json['artist']} - ${json['name']}';
      });
      playAnimation();
    });
    return Response.ok('ACK', headers: {'Access-Control-Allow-Origin': '*'});
  }

  void playAnimation() {
    if (controller.isCompleted || controller.isAnimating) {
      controller.reset();
    }

    timer?.cancel();

    controller.forward().whenComplete(() {
      timer =
          Timer(Duration(milliseconds: animationHoldMilliseconds.toInt()), () {
        controller.reverse();
      });
    });
  }

  Widget getPopup() {
    switch (popup) {
      case 'SlidePopup':
        return SlidePopup(state: this);
      case 'WindowPopup':
        return WindowPopup(state: this);
      default:
        return SlidePopup(state: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    popupWidth = MediaQuery.of(context).size.width * widthFactor;

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              MouseRegion(
                onHover: (event) {
                  setState(() {
                    settingsButtonVisible = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    settingsButtonVisible = false;
                  });
                },
                child: AnimatedOpacity(
                  opacity: settingsButtonVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Settings(
                          onWidthFactorChanged: (value) {
                            setState(() {
                              widthFactor = value;
                              popupWidth = MediaQuery.of(context).size.width *
                                  widthFactor;
                              storage.setDouble('widthFactor', widthFactor);
                            });
                          },
                          onStyleCardHoverChanged: (index, value) {
                            setState(() {
                              styleCardHover[index] = value;
                            });
                          },
                          onStyleChanged: (style) {
                            setState(() {
                              popup = style;
                              storage.setString('popup', popup);
                            });
                          },
                          onColorChanged: (newColor) {
                            setState(() {
                              globalColor = newColor;
                              storage.setString('globalColor', globalColor.toHex());
                            });
                          },
                          onTextSizeChanged: (newTextSize) {
                            setState(() {
                              textSize = newTextSize;
                              storage.setDouble('textSize', textSize);
                            });
                          },
                          onPopupPaddingChanged: (newPopupPadding) {
                            setState(() {
                              popupPadding = newPopupPadding;
                              storage.setDouble('popupPadding', popupPadding);
                            });
                          },
                          onAnimationMillisecondsChanged:
                              (newAnimationMilliseconds) {
                            setState(() {
                              animationMilliseconds = newAnimationMilliseconds;
                              controller.duration = Duration(milliseconds: animationMilliseconds.toInt());
                              storage.setDouble('animationMilliseconds', animationMilliseconds);
                            });
                          },
                          onAnimationHoldMillisecondsChanged:
                              (newAnimationHoldMillisecondsChanged) {
                            setState(() {
                              animationHoldMilliseconds =
                                  newAnimationHoldMillisecondsChanged;
                              storage.setDouble('animationHoldMilliseconds', animationHoldMilliseconds);
                            });
                          },
                          color: globalColor,
                          state: this,
                        ),
                      );
                    },
                    icon: Icon(Icons.settings_outlined),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: SlideTransition(position: offset, child: getPopup()),
          ),
        ],
      ),
    );
  }
}
