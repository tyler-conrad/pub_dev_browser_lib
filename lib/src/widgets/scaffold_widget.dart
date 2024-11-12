import 'package:flutter/material.dart' as m;

import 'package:go_router/go_router.dart' as go;

import '../logger.dart' as l;

/// Scaffold widget that provides a basic layout for the application.
///
/// This widget is shared by all screens of the application.  It provides a back
/// button to navigate to the previous screen and a title bar that displays the
/// name of the application. Logs whether the back button was pressed when the
/// routing stack is empty.
class Scaffold extends m.StatelessWidget {
  const Scaffold({super.key, required this.child});

  final m.Widget child;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.SafeArea(child: child),
      appBar: m.AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const m.Text('Unofficial pub.dev Browser'),
        actions: [
          m.SizedBox(
            width: 52.0,
            child: m.BackButton(onPressed: () {
              if (go.GoRouter.of(context).canPop()) {
                context.pop();
              } else {
                l.log.i('Cannot pop().');
              }
            }),
          ),
        ],
      ),
    );
  }
}
