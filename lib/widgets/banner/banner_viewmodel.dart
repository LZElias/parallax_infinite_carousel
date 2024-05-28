import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../util/constants.dart';

class BannerViewModel extends BaseViewModel {
  final ValueNotifier<bool> _showVideo = ValueNotifier(false);

  ValueNotifier<bool> get showVideo => _showVideo;

  final ValueNotifier<bool> _isVideoMuted = ValueNotifier(true);

  ValueNotifier<bool> get isVideoMuted => _isVideoMuted;

  final PageController _pageController = PageController(
    initialPage: initialPageNumber,
  );

  PageController get pageController => _pageController;

  final ValueNotifier<double> _horizontalScrollPosition = ValueNotifier(
    initialPageNumber.toDouble(),
  );

  ValueNotifier<double> get horizontalScrollPosition =>
      _horizontalScrollPosition;

  final ValueNotifier<double> _verticalScrollPosition = ValueNotifier(0);

  ValueNotifier<double> get verticalScrollPosition => _verticalScrollPosition;

  final ValueNotifier<int> _currentBannerIndex = ValueNotifier(0);

  ValueNotifier<int> get currentBannerIndex => _currentBannerIndex;

  late final ScrollPosition _scrollPosition;
  late final double _bannerHeight;

  BetterPlayerController get betterPlayerController => _betterPlayerController;
  late final BetterPlayerController _betterPlayerController;

  void init({
    required ScrollPosition scrollPosition,
    required double bannerHeight,
    required double screenWidth,
  }) async {
    _scrollPosition = scrollPosition;
    _bannerHeight = bannerHeight;

    _scrollPosition.addListener(_onVerticalScroll);
    _pageController.addListener(_onHorizontalScroll);

    final aspectRatio = screenWidth / bannerHeight;
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          showControls: false,
        ),
        autoDispose: false,
        autoPlay: true,
        fit: BoxFit.cover,
        aspectRatio: aspectRatio,
      ),
    )..addEventsListener(_onVideoEventChange);
  }

  void _onVerticalScroll() {
    _verticalScrollPosition.value =
        (_scrollPosition.pixels / _bannerHeight).clamp(0, 1);
  }

  void _onHorizontalScroll() =>
      _horizontalScrollPosition.value = _pageController.page ?? 0;

  int getCurrentBannerIndex(int currentIndex) {
    final currentIndexMinusPageNumber = currentIndex - initialPageNumber;
    final bannersLength = banners.length;

    if (currentIndexMinusPageNumber.isNegative) {
      return (currentIndexMinusPageNumber + bannersLength) % bannersLength;
    }

    return currentIndexMinusPageNumber % bannersLength;
  }

  void onPageChanged(int index) {
    _showVideo.value = false;
    currentBannerIndex.value = getCurrentBannerIndex(index);

    final currentBanner = banners[_currentBannerIndex.value];
    String url = currentBanner.videoUrl ?? '';

    final bool isInit = betterPlayerController.videoPlayerController != null;
    if (url.isEmpty && isInit) {
      betterPlayerController.pause();
      betterPlayerController.clearCache();
    }

    if (url.isEmpty) {
      return;
    }

    betterPlayerController.setupDataSource(
      BetterPlayerDataSource(BetterPlayerDataSourceType.network, url),
    );

    betterPlayerController.addEventsListener(_onVideoEventChange);
  }

  bool bannerImageHasVideo() =>
      (banners[_currentBannerIndex.value].videoUrl ?? '').isNotEmpty;

  void _onVideoEventChange(BetterPlayerEvent event) async {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        _isVideoMuted.value = true;
        _showVideo.value = false;
        await _betterPlayerController.videoPlayerController?.setVolume(0);
        _showVideo.value = true;
        break;
      case BetterPlayerEventType.setVolume:
        final currentVolume =
            betterPlayerController.videoPlayerController?.value.volume ?? 0;
        _isVideoMuted.value = currentVolume == 0;
        break;
      case BetterPlayerEventType.finished:
      case BetterPlayerEventType.exception:
        _showVideo.value = false;
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _betterPlayerController.removeEventsListener(_onVideoEventChange);
    super.dispose();
  }
}
