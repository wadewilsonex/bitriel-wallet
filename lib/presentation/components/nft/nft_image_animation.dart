import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wallet_apps/index.dart';

class ImageListView extends StatefulWidget {
  const ImageListView({Key? key, required this.startIndex, this.duration = 30})
      : super(key: key);

  final int startIndex;

  final int duration;

  @override
  ImageListViewState createState() => ImageListViewState();
}

class ImageListViewState extends State<ImageListView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      //Detect if is at the end of list view
      if (_scrollController.position.atEdge) {
        _autoScroll();
      }
    });

    //Add this to make sure that controller has been attacted to List View
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoScroll();
    });
  }

  _autoScroll() {
    final currentScrollPosition = _scrollController.offset;

    final scrollEndPosition = _scrollController.position.maxScrollExtent;

    scheduleMicrotask(() {
      _scrollController.animateTo(
        currentScrollPosition == scrollEndPosition ? 0 : scrollEndPosition,
        duration: Duration(seconds: widget.duration),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 1.94 * pi,
      child: SizedBox(
        height: 20.vmax,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: 9,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Consumer<AppProvider>(
              builder: (context, pro, wg) {
                return _imageTile(context, '${pro.dirPath}/nfts/rieltiger/${widget.startIndex + index}.png');
              }
            );
          },
        ),
      ),
    );
  }
}
Widget _imageTile(
  BuildContext context,
  String? image
) {
  return Image.file(
    File(image!),
    width: 130,
  );
}
