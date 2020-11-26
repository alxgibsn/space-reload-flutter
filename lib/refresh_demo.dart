import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:space_reload_flutter/demo.dart';
import 'package:space_reload_flutter/refresh_controller.dart';

class RefreshControlDemo extends StatefulWidget {

  final Demo demo;
  const RefreshControlDemo(this.demo, {Key key}) : super(key: key);

  @override
  _RefreshControlDemoState createState() => _RefreshControlDemoState();
}

class _RefreshControlDemoState extends State<RefreshControlDemo> {

  Artboard _artboard;
  RefreshController _controller;

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  /// Loads a Rive file
  void _loadRiveFile() async {
    final bytes = await rootBundle.load('assets/${widget.demo.riveFile}.riv');
    final file = RiveFile();
    if (file.import(bytes)) {
      setState(() => _artboard = file.mainArtboard
        ..addController(_controller = RefreshController()
      ));
    }
  }

  Widget buildRefreshWidget(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent) {

    _controller.refreshState = refreshState;
    _controller.pulledExtent = pulledExtent;
    _controller.triggerThreshold = refreshTriggerPullDistance;
    _controller.refreshIndicatorExtent = refreshIndicatorExtent;

    return _artboard != null
      ? Rive(
        artboard: _artboard,
        fit: BoxFit.cover,
        alignment: widget.demo.alignment)
      : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.demo.navTitle),
        backgroundColor: widget.demo.navColor),
      backgroundColor: widget.demo.backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            _controller.reset();
          }
          return true;
        },
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 240.0,
              refreshIndicatorExtent: 240.0,
              builder: buildRefreshWidget,
              onRefresh: () {
                return Future<void>.delayed(const Duration(seconds: 5))
                  ..then<void>((_) {
                    if (mounted) {
                      setState((){});
                    }
                  });
              },
            ),
            SliverSafeArea(
              top: false, // Top safe area is consumed by the navigation bar.
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SizedBox(
                      height: 150,
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        decoration: BoxDecoration(
                          color: widget.demo.tileColor,
                          borderRadius: BorderRadius.circular(5)
                        ),
                      )
                    );
                  },
                  childCount: 10,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}