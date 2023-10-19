import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_blurhash/flutter_blurhash.dart';

void main() => runApp(const POC());

class POC extends StatelessWidget {
  const POC({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POC',
      theme: ThemeData(useMaterial3: true),
      home: const POCWidget(),
    );
  }
}

class POCWidget extends StatelessWidget {
  const POCWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POC'),
        centerTitle: true,
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: listWith20HashsDifferents.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => goTo(
                context: context,
                index: index,
                blurHash: listWith20HashsDifferents[index],
              ),
              child: Hero(
                tag: 'image$index',
                child: BlurHash(
                  hash: listWith20HashsDifferents[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MediaHeaderSliver extends StatefulWidget {
  const MediaHeaderSliver({
    super.key,
    required this.coverUrl,
    required this.blurHash,
  });

  final String coverUrl, blurHash;

  @override
  State<MediaHeaderSliver> createState() => _MediaHeaderSliverState();
}

class _MediaHeaderSliverState extends State<MediaHeaderSliver> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blurhash = widget.blurHash;

    return Scaffold(
      body: Stack(
        children: [
          BlurHash(hash: blurhash),
          SafeArea(
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              slivers: [
                SliverCustomAppBar(
                  blurHash: blurhash,
                  maxAppBarHeight: maxAppBarHeight,
                  minAppBarHeight: minAppBarHeight,
                  mediaUrl: widget.coverUrl,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    const ColoredBox(
                      color: Colors.white,
                      child: MediaListTileItems(),
                    ),
                  ]),
                ),
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: ColoredBox(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderCarousel extends StatefulWidget {
  const HeaderCarousel({
    super.key,
    required this.mediaImageSize,
    required this.mediaUrl,
  });

  final double mediaImageSize;
  final String mediaUrl;

  @override
  State<HeaderCarousel> createState() => _HeaderCarouselState();
}

class _HeaderCarouselState extends State<HeaderCarousel> {
  late PageController pageViewController;
  double currentPage = 0.0;

  bool isCurrentIndex(int index) => currentPage.round() == index;
  void pageControllerListener() =>
      setState(() => currentPage = pageViewController.page ?? 0);

  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
    pageViewController.addListener(pageControllerListener);
  }

  @override
  void dispose() {
    pageViewController.removeListener(pageControllerListener);
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const indicatorSize = 10.0;
    const indicatorsSizeWithPadding = indicatorSize + 10.0;
    const carouselDuration = Duration(milliseconds: 250);
    const currentColor = Colors.pink;

    final List<Widget> carouselItems = [
      MediaImage(
        mediaImageSize: widget.mediaImageSize,
        mediaImageUrl: widget.mediaUrl,
      ),
      const HeaderDescription(
        description: mockDescription,
        colorTitle: Colors.white,
      ),
    ];

    final indicatorsTotalWidth =
        carouselItems.length * indicatorsSizeWithPadding;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            width: context.width,
            height: context.height,
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: pageViewController,
              physics: const BouncingScrollPhysics(),
              itemCount: carouselItems.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  duration: carouselDuration,
                  opacity: isCurrentIndex(index) ? 1 : 0,
                  child: carouselItems[index],
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: indicatorSize,
                  width: indicatorsTotalWidth,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: carouselItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => pageViewController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                        child: Container(
                          width: indicatorSize,
                          height: indicatorSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isCurrentIndex(index)
                                    ? currentColor
                                    : Colors.transparent,
                                blurRadius: 4,
                                spreadRadius: 0.75,
                              ),
                            ],
                            color: isCurrentIndex(index)
                                ? currentColor
                                : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SliverCustomAppBar extends StatelessWidget {
  const SliverCustomAppBar({
    super.key,
    required this.maxAppBarHeight,
    required this.minAppBarHeight,
    required this.mediaUrl,
    required this.blurHash,
    this.description,
  });

  final double maxAppBarHeight, minAppBarHeight;
  final String mediaUrl, blurHash;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        maxHeight: maxAppBarHeight,
        minHeight: minAppBarHeight,
        builder: (context, shrinkOffset, overlap) {
          final shrinkToMaxAppBarHeightRatio = shrinkOffset / maxAppBarHeight;
          final showFixedAppBar =
              shrinkToMaxAppBarHeightRatio > ratioToHideFixedAppBar;

          return Stack(
            children: [
              Visibility(
                visible: showFixedAppBar,
                maintainState: true,
                child: ClipRect(
                  clipBehavior: Clip.antiAlias,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    maxHeight: context.height,
                    child: BlurHash(hash: blurHash),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: context.pop,
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Visibility(
                        visible: !showFixedAppBar,
                        maintainState: true,
                        child: HeaderCarousel(
                          mediaImageSize: mediaCoverSize - shrinkOffset,
                          mediaUrl: mediaUrl,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MediaImage extends StatelessWidget {
  const MediaImage({
    super.key,
    required this.mediaImageSize,
    required this.mediaImageUrl,
  });

  final double mediaImageSize;
  final String mediaImageUrl;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: mediaImageSize,
              width: mediaImageSize,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 0.75,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(mediaImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderDescription extends StatelessWidget {
  const HeaderDescription({
    super.key,
    required this.description,
    required this.colorTitle,
  });

  final String description;
  final Color colorTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(0, 60, 0, 24),
      child: Text(
        description,
        maxLines: 6,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colorTitle,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

typedef SliverAppBarDelegateBuilder = Widget Function(
  BuildContext context,
  double shrinkOffset,
  bool overlapsContent,
);

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  final double minHeight, maxHeight;
  final SliverAppBarDelegateBuilder builder;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: builder(context, shrinkOffset, overlapsContent),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        builder != oldDelegate.builder;
  }
}

class MediaListTile extends StatelessWidget {
  const MediaListTile({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListTile(
        title: Text('$index. Lorem ipsum dolor sit amet'),
      ),
    );
  }
}

class MediaListTileItems extends StatelessWidget {
  const MediaListTileItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 50; i++) MediaListTile(index: i),
      ],
    );
  }
}

extension BuildContextX on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
  double get statusBarSize => MediaQuery.paddingOf(this).top;

  void pop<T>([T? result]) => Navigator.pop(this, result);
  void navigateTo(Widget nextPage) {
    Navigator.push(
      this,
      NoTransitionPageRoute(
        builder: (context) => nextPage,
        fullscreenDialog: false,
        settings: RouteSettings(
          name: nextPage.toString(),
        ),
      ),
    );
  }
}

const maxAppBarHeight = 210.0;
const minAppBarHeight = 80.0;
const paddingBetweenButtonElements = 45.0;
const playPauseSize = 60.0;
const mediaCoverSize = 190.0;
const ratioToHideFixedAppBar = 0.65;
const mockDescription =
    'lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborumlorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborumlorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborumlorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborumlorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborumlorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum';

final listWith20HashsDifferents = [
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LmNAC-%2-;V@_NW;WCWBNvofaeoz',
  'LGIWH3]-M{tk~V=f%1w|x]xGwIWB',
  'LnI}O=%2xut7~Wf6S4flIoRjD*WB',
  'L9EAr@1M+u,CtO%1%J5R^0}r]%I;',
  'LZL{uC-;R;-:~WnTbJt4^3VtOEsk',
  'LGIWH3]-M{tk~V=f%1w|x]xGwIWB',
  'L05}v:00S%?a4URkDjoz00~q-oIB',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LIGbk,~qxu%MRjWBayayRjayjtay',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LmNAC-%2-;V@_NW;WCWBNvofaeoz',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LmNAC-%2-;V@_NW;WCWBNvofaeoz',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LGFysrNZvr=g=*]=NEai7]oMFWNZ',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LhN]@9~VD*^+HrVstRni00MzxuRP',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LjJkchxZ_Nt8ofaeRPWB?bozayof',
  'LnI}O=%2xut7~Wf6S4flIoRjD*WB',
  'L9EAr@1M+u,CtO%1%J5R^0}r]%I;',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'LmNAC-%2-;V@_NW;WCWBNvofaeoz',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'L9EAr@1M+u,CtO%1%J5R^0}r]%I;',
  'LmNAC-%2-;V@_NW;WCWBNvofaeoz',
  'LDQTAgxu~UM|o~%1w[E2=^ay9bR+',
  'L8H,LuIV4WNL~D5R,,WD66EgAZxC',
];

void goTo({
  required BuildContext context,
  required int index,
  required String blurHash,
}) {
  context.navigateTo(
    MediaHeaderSliver(
      coverUrl: 'https://picsum.photos/1000?random=$index',
      blurHash: blurHash,
    ),
  );
}

class NoTransitionPageRoute<T> extends PageRoute<T> {
  NoTransitionPageRoute({
    RouteSettings? settings,
    required this.builder,
    bool fullscreenDialog = false,
  }) : super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  final WidgetBuilder builder;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      builder(context);

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
