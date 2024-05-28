import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:parallax_infiniter_carousel/models/banner_data.dart';
import 'package:parallax_infiniter_carousel/util/constants.dart';
import 'package:parallax_infiniter_carousel/widgets/banner/banner_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final mQuery = MediaQuery.of(context);
    final size = mQuery.size;
    final bannerHeight = size.height * 0.7;

    return ViewModelBuilder<BannerViewModel>.nonReactive(
      viewModelBuilder: () => BannerViewModel(),
      onViewModelReady: (vm) => vm.init(
        scrollPosition: Scrollable.of(context).position,
        bannerHeight: bannerHeight,
        screenWidth: size.width,
      ),
      builder: (context, viewModel, child) {
        return SizedBox(
          height: bannerHeight,
          child: PageView.builder(
            onPageChanged: (index) => viewModel.onPageChanged(index),
            physics: const ClampingScrollPhysics(),
            controller: viewModel.pageController,
            itemBuilder: (context, currIndex) {
              final index = viewModel.getCurrentBannerIndex(currIndex);
              final bannerItem = banners.elementAt(index);
              final currentBannerIndex = viewModel.getCurrentBannerIndex(index);

              return ValueListenableBuilder<double>(
                valueListenable: viewModel.horizontalScrollPosition,
                builder: (context, value, child) {
                  double xCoordinatePosition =
                      (value - currIndex) * (size.width / 2);

                  return ValueListenableBuilder<double>(
                    valueListenable: viewModel.verticalScrollPosition,
                    builder: (context, value, _) {
                      double yCoordinatePosition = 0;
                      yCoordinatePosition = value * (size.width / 2);

                      return ClipRRect(
                        borderRadius: BorderRadius.zero,
                        clipBehavior: Clip.hardEdge,
                        child: AnimatedContainer(
                          duration: Duration.zero,
                          transform: Matrix4.translationValues(
                            xCoordinatePosition,
                            yCoordinatePosition,
                            0.0,
                          ),
                          child: child,
                        ),
                      );
                    },
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: viewModel.showVideo,
                      builder: (context, showVideo, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          reverseDuration: const Duration(milliseconds: 200),
                          transitionBuilder: (
                            Widget child,
                            Animation<double> animation,
                          ) {
                            return FadeTransition(
                              opacity: CurvedAnimation(
                                parent: animation,
                                curve: Curves.ease,
                              ),
                              child: child,
                            );
                          },
                          child: showVideo &&
                                  viewModel.currentBannerIndex.value ==
                                      currentBannerIndex
                              ? BetterPlayer(
                                  controller: viewModel.betterPlayerController,
                                )
                              : SizedBox(
                                  width: size.width,
                                  child: Image.asset(
                                    bannerItem.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        );
                      },
                    ),
                    Image.asset(
                      'assets/images/banner_gradient.png',
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                      color: Colors.lightBlue,
                    ),
                    //there is a transparent line between the image and gradient so the container removes it
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 5,
                        width: size.width,
                        color: Colors.lightBlue,
                      ),
                    ),
                    Positioned(
                      bottom: 44,
                      height: bannerHeight,
                      width: size.width,
                      child: ValueListenableBuilder<double>(
                        valueListenable: viewModel.horizontalScrollPosition,
                        builder: (context, value, child) {
                          final currentImagePos = value - currIndex;

                          return AnimatedOpacity(
                            opacity: (currentImagePos < 0
                                    ? 1 + currentImagePos
                                    : 1 - currentImagePos)
                                .clamp(0, 1),
                            duration: Duration.zero,
                            child: _BannerDetails(
                              bannerHeight: bannerHeight,
                              currentBanner: bannerItem,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _BannerDetails extends StatelessWidget {
  const _BannerDetails({
    Key? key,
    required this.bannerHeight,
    required this.currentBanner,
  }) : super(key: key);

  final double bannerHeight;
  final BannerData currentBanner;

  @override
  Widget build(BuildContext context) {
    final title = currentBanner.title ?? '';
    final description = currentBanner.description ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              maxLines: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
