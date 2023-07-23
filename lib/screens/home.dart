import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz1/screens/brain/quote_brain.dart';

import 'animation/rotate_animation.dart';

class HomeScreen extends StatefulWidget {
  final QuoteBrain quoteBrain;
  const HomeScreen({
    Key? key,
    required this.quoteBrain,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late QuoteBrain brain;

  @override
  void initState() {
    brain = widget.quoteBrain;
    brain.setState = () {
      setState(() {});
    };
    brain.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: AnimatedRotation(
            turns: brain.turns,
            duration: brain.duration,
            child: const Text('Quotes')),
        actions: [
          AnimatedRotation(
            turns: brain.turns,
            duration: brain.duration,
            child: IconButton(
                onPressed: () async {
                  brain.refreshIndicatorKey.currentState?.show();
                  // await brain.getData();
                },
                icon: const Icon(Icons.refresh)),
          )
        ],
      ),
      body: RepaintBoundary(
        key: brain.globalKey,
        child: RefreshIndicator(
          key: brain.refreshIndicatorKey,
          onRefresh: brain.getData,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.6), BlendMode.dstATop),
                        image: brain.getImage(),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: AnimatedSlide(
                      duration: brain.duration,
                      curve: Curves.ease,
                      offset: brain.offset ?? Offset(size.width / 2, 0),
                      child: AnimatedScale(
                        scale: brain.scale,
                        duration: brain.duration,
                        child: AnimatedRotation(
                          turns: brain.turns,
                          duration: brain.duration,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            padding: const EdgeInsets.all(18),
                            decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadiusDirectional.only(
                                    bottomStart: Radius.circular(30),
                                    topEnd: Radius.circular(30))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: RotatedBox(
                                          quarterTurns: 2,
                                          child: SvgPicture.asset(
                                              'images/quote-right-svgrepo-com.svg',
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcATop)),
                                        ),
                                      ),
                                      const WidgetSpan(
                                          child: SizedBox(
                                        width: 8,
                                      )),
                                      TextSpan(
                                        text: brain.content,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: SvgPicture.asset(
                                            'images/quote-right-svgrepo-com.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcATop),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "${brain.author}--${brain.date}",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedRotation(
        turns: brain.turns,
        duration: brain.duration,
        child: FloatingActionButton.extended(
          onPressed: () async {
            await brain.capturePng(context, mounted);
          },
          label: const Text('Share quorte'),
          icon: const Icon(Icons.share),
        ),
      ),
    );
  }
}
