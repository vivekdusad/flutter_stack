import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RawMaterialButton(
                fillColor: Colors.blue,
                onPressed: _showBasicsFlash,
                child: const Text('show Basic Flash'),
              ),
              RawMaterialButton(
                fillColor: Colors.blue,
                onPressed: _showTopFlash,
                child: const Text('show Top Flash'),
              ),
              RawMaterialButton(
                fillColor: Colors.blue,
                onPressed: _showBottomFlash,
                child: const Text('show Bottom Flash'),
              ),
              RawMaterialButton(
                fillColor: Colors.blue,
                onPressed: _showInputFlash,
                child: const Text('show Input Flash'),
              ),
              RawMaterialButton(
                fillColor: Colors.blue,
                onPressed: _showDialogFlash,
                child: const Text('show Dialog Flash'),
              ),
              RawMaterialButton(
                fillColor: Colors.blue,
                onPressed: () {
                  _showMessage("Flutter Stack");
                },
                child: const Text('show Message Flash'),
              ),
            ],
          ),
        ));
  }

  void _showBasicsFlash({
    Duration? duration,
    flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: const Text('This is a basic flash'),
          ),
        );
      },
    );
  }

  void _showTopFlash({FlashBehavior style = FlashBehavior.floating}) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      persistent: false,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          boxShadows: const [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: const Text('Title'),
            content: const Text('Hello world!'),
            showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child:
                  const Text('DISMISS', style: TextStyle(color: Colors.amber)),
            ),
          ),
        );
      },
    );
  }

  void _showBottomFlash({
    bool persistent = true,
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    showFlash(
      context: context,
      persistent: persistent,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          margin: margin,
          behavior: FlashBehavior.fixed,
          position: FlashPosition.bottom,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Colors.blue,
          boxShadows: kElevationToShadow[8],
          backgroundGradient: const RadialGradient(
            colors: [Colors.amber, Colors.black87],
            center: Alignment.topLeft,
            radius: 2,
          ),
          onTap: () => controller.dismiss(),
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: FlashBar(
              title: const Text('Hello Flash'),
              content:
                  const Text('You can put any message of any length here.'),
              indicatorColor: Colors.red,
              icon: const Icon(Icons.info_outline),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: const Text('DISMISS'),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => controller.dismiss('Yes, I do!'),
                    child: const Text('YES')),
                TextButton(
                    onPressed: () => controller.dismiss('No, I do not!'),
                    child: const Text('NO')),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (_ != null) {
        _showMessage(_.toString());
      }
    });
  }

  void _showInputFlash({
    bool persistent = true,
    WillPopCallback? onWillPop,
    Color? barrierColor,
  }) {
    var editingController = TextEditingController();
    context.showFlashBar(
      persistent: persistent,
      onWillPop: onWillPop,
      barrierColor: barrierColor,
      borderWidth: 3,
      behavior: FlashBehavior.fixed,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: const Text('Hello Flash'),
      content: Column(
        children: [
          const Text('You can put any message of any length here.'),
          Form(
            child: TextFormField(
              controller: editingController,
              autofocus: true,
            ),
          ),
        ],
      ),
      indicatorColor: Colors.red,
      primaryActionBuilder: (context, controller, _) {
        return IconButton(
          onPressed: () {
            if (editingController.text.isEmpty) {
              controller.dismiss();
            } else {
              var message = editingController.text;
              _showMessage(message);
              editingController.text = '';
            }
          },
          icon: const Icon(Icons.send, color: Colors.amber),
        );
      },
    );
  }

  void _showDialogFlash({bool persistent = true}) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        persistent: persistent,
        title: const Text('Flash Dialog'),
        content: const Text(
            '⚡️A highly customizable, powerful and easy-to-use alerting library for Flutter.'),
        negativeActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss();
            },
            child: const Text('NO'),
          );
        },
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
              onPressed: () {
                controller.dismiss();
              },
              child: const Text('YES'));
        });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.top,
            behavior: FlashBehavior.fixed,
            child: FlashBar(
              icon: const Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              content: Text(message),
            ),
          );
        });
  }

  
}



