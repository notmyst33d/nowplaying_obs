import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'server.dart';

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

  String currentSong = 'None';

  late final AnimationController controller = AnimationController(
    duration: Duration(seconds: 1),
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

  Widget Popup() {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF8C9EFF)),
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
        child: Row(
          children: [
            Text(
              'Now Playing',
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.music_note, color: Colors.white),
            Text(
              currentSong,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void playAnimation() {
    if (controller.isCompleted || controller.isAnimating) {
      controller.reset();
    }

    timer?.cancel();

    controller.forward().whenComplete(() {
      timer = Timer(Duration(seconds: 3), () {
        controller.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          SlideTransition(
            position: offset,
            child: Popup(),
          ),
        ],
      ),
    );
  }
}
