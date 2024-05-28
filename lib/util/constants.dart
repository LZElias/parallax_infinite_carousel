import '../models/banner_data.dart';

final List<BannerData> banners = [
  BannerData(
    title: 'Banner 1',
    description: 'This is a temporary description',
    imagePath: 'assets/banners/1.jpeg',
  ),
  BannerData(
    title: 'Banner 2',
    description:
        'This is a very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very very loooooooong temporary description',
    imagePath: 'assets/banners/2.jpeg',
  ),
  BannerData(
    title: 'Banner 3',
    videoUrl:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    imagePath: 'assets/banners/3.jpeg',
  ),
  BannerData(
    imagePath: 'assets/banners/4.jpeg',
  ),
  BannerData(
    description:
        'This is a very very very very very very very very very loooooooong temporary description',
    imagePath: 'assets/banners/5.jpeg',
  ),
];

const int initialPageNumber = 1000;
