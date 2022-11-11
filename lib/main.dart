import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _insertOverlay(context));
            return Navigator(
              key: _navigatorKey,
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/page2':
                    return MaterialPageRoute(builder: (_) => Page2());
                  default:
                    return MaterialPageRoute(builder: (_) => Page1(_navigatorKey));
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _insertOverlay(BuildContext context) {
    return Overlay.of(context)!.insert(
      OverlayEntry(builder: (context) {
        final size = MediaQuery.of(context).size;
        print(size.width);
        return Positioned(
          width: Get.width,
          height: 60,
          bottom: 0,
          left: 0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => print('ON TAP OVERLAY!'),
              child: Container(
                width: Get.width,
                height: 60,
                decoration: BoxDecoration(color: Colors.grey),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        print('전체화면');
                      },
                      child: Container(
                        color: Colors.red,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('제목제목제목제목제목제목제목제목'),
                              Text('가수가수가수가수가수가수가수가수'),
                            ]
                        )
                      ),
                    ),
                    const Spacer(),
                    Container(
                      color: Colors.yellow,
                      child: IconButton(icon: Icon(Icons.skip_previous), onPressed: ()=> print('prev'),),
                    ),
                    Container(
                      color: Colors.green,
                      child: IconButton(icon: Icon(Icons.play_arrow), onPressed: ()=> print('play'),),
                    ),
                    Container(
                      color: Colors.yellow,
                      child: IconButton(icon: Icon(Icons.skip_next), onPressed: ()=> print('next'),),
                    ),
                    const SizedBox(width: 20),
                  ]
                )
              ),
            ),
          ),
        );
      }),
    );
  }
}

class Page1 extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  Page1(this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(title: Text('Page1')),
      body: Container(
        alignment: Alignment.center,
        child: TextButton(
          child: Text('go to Page2'),
          onPressed: () => navigatorKey.currentState!.pushNamed('/page2'),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(title: Text('back to Page1')),
      body: Container(
        alignment: Alignment.center,
        child: Text('Page 2'),
      ),
    );
  }
}