import 'package:flutter/material.dart';
import 'package:parallax_infiniter_carousel/widgets/banner/banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const BannerView(),
            Container(
              height: 200,
              width: double.maxFinite,
              color: Colors.lightBlue,
              child: const Center(
                child: Text('Some data'),
              ),
            ),
            Container(
              height: 200,
              width: double.maxFinite,
              color: Colors.pink,
              child: const Center(
                child: Text('Some data'),
              ),
            ),
            Container(
              height: 200,
              width: double.maxFinite,
              color: Colors.yellow,
              child: const Center(
                child: Text('Some data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
