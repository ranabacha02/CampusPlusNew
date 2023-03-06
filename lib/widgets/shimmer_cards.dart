import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'card_skeleton.dart';

class ShimmerCards extends StatelessWidget {
  const ShimmerCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade900,
          highlightColor: Colors.grey.shade100,
          child: ListView.separated(
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) => const CardSkeleton(),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemCount: 5
          )
      ),
    );
  }
}
