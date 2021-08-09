import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:flutter/material.dart';

class NowPlayingServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Now Playing OBS Server',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: NowPlayingServer(),
    );
  }
}

class NowPlayingServer extends StatefulWidget {
  @override
  NowPlayingServerState createState() {
    final stateClass = NowPlayingServerState();
    stateClass.setupServer();
    return stateClass;
  }
}

class NowPlayingServerState extends State<NowPlayingServer> {
  late final router = shelf_router.Router()..post('/', onUpdate)..get('/update', getUpdate);
  late final cascade = Cascade().add(router);
  late final server;

  var currentSong = 'None';

  Future setupServer() async {
    server = await shelf_io.serve(
      logRequests().addHandler(cascade.handler),
      InternetAddress.anyIPv4,
      50142,
    );
  }

  Response onUpdate(Request request) {
    request.readAsString().then((body) {
      final json = jsonDecode(body);
      setState(() {
        currentSong = '${json['artist']} - ${json['name']}';
      });
    });
    return Response.ok('ACK', headers: {'Access-Control-Allow-Origin': '*'});
  }

  Response getUpdate(Request request) {
    return Response.ok(currentSong, headers: {'Access-Control-Allow-Origin': '*'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Server running, add Browser element to OBS with https://notmyst33d.github.io/nowplaying_obs link',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
