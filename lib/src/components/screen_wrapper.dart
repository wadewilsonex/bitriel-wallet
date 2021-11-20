import 'package:flutter/material.dart';

import '../../app.dart';

class ScreenWrapper extends StatefulWidget {
  final Widget? child;
  final Function()? onLeaveScreen;
  final Function()? onGoingBack;
  final String? routeName;
  ScreenWrapper(
      {this.child,
      this.onLeaveScreen,
      this.onGoingBack,
      @required this.routeName});

  @override
  State<StatefulWidget> createState() {
    return ScreenWrapperState();
  }
}

class ScreenWrapperState extends State<ScreenWrapper> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  void onLeaveScreen() {
    if (widget.onLeaveScreen != null) {
      widget.onLeaveScreen!();
    }
  }

  void onGoingBack() {
    if (widget.onGoingBack != null) {
      widget.onGoingBack!();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver!.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver!.unsubscribe(this);
  }

  @override
  void didPush() {
    // print('*** Entering screen: ${widget.routeName}');
  }

  void didPushNext() {
//print('*** Leaving screen: ${widget.routeName}');
    onLeaveScreen();
  }

  @override
  void didPop() {
    // print('*** Going back, leaving screen: ${widget.routeName}');
    onLeaveScreen();
  }

  @override
  void didPopNext() {
    //print('*** Going back to screen: ${widget.routeName}');
    onGoingBack();
  }
}
