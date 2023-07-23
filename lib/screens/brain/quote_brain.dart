import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/image.dart';
import '../../models/quote.dart';
import '../../services/fetch_data.dart';

import '../../services/share_screen_shot.dart';

class QuoteBrain {
  late Quote quote;
  late QImage image;
  late ImageProvider imageProvider;
  late String content;
  late String author;
  late String date;
  final String baseUrl =
      'https://images.unsplash.com/photo-1539724728401-4337be9859ba?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=1080&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY5MDExNTI1OQ&ixlib=rb-4.0.3&q=80&w=1920';
  late VoidCallback setState;
  bool isLoaded = false;
  ImageProvider assetImage = const AssetImage('images/background.jpg');
  late ImageProvider networkImage;
  double turns = 0;
  Duration duration = const Duration(milliseconds: 350);
  double scale = 1;
  late Offset offset;
  List<int> points = [-1, 1];
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  void init() {
    setImage();
    update();
  }

  update() {
    content = quote.content ?? '';
    author = quote.authorSlug ?? '';
    date = quote.dateModified ?? '';
    animate();
  }

  void setIsLoaded(bool value) {
    isLoaded = value;
  }

  void setNetworkImage() {
    networkImage = NetworkImage(image.url ?? baseUrl);
  }

  void imageListener() {
    networkImage
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((image, synchronousCall) {
      print("change Now");
      setIsLoaded(true);
      setState();
    }));
  }

  setImage() {
    setIsLoaded(false);
    setState();
    setNetworkImage();
    imageListener();
  }

  ImageProvider getImage() {
    return isLoaded ? networkImage : assetImage;
  }

  Future<void> getData() async {
    ApiHelper apiHelper = ApiHelper();
    quote = await apiHelper.fetchQuote();
    image = await apiHelper.fetchImage(quote.tags?[0] ?? 'sport');
    setImage();
    update();
  }

  GlobalKey globalKey = GlobalKey();

  Future<void> capturePng(BuildContext context, bool mounted) async {
    ShareScreenHelper.capturePng(context,
        mounted: mounted, globalKey: globalKey);
  }

  Future<void> rotate() async {
    turns += 0.5;
    setState();
    await Future.delayed(duration);
    turns += 0.5;
    setState();
  }

  Future<void> scaleWidget() async {
    scale = 0.1;
    setState();
    await Future.delayed(duration);
    scale = 1;
    setState();
  }

  Future<void> slide() async {
    offset = Offset(points[Random().nextInt(2)].toDouble(),
        points[Random().nextInt(2)].toDouble());
    setState();
    await Future.delayed(
        Duration(milliseconds: (duration.inMilliseconds / 2).round()));
    offset = Offset(points[Random().nextInt(2)].toDouble(),
        points[Random().nextInt(2)].toDouble());
    setState();
    await Future.delayed(
        Duration(milliseconds: (duration.inMilliseconds / 2).round()));
    offset = Offset.zero;
    setState();
  }

  void animate() async {
    ///if i add await the animation well look slower
    slide();
    scaleWidget();
    rotate();
  }
}
