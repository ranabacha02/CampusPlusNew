import 'package:flutter/material.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.92 : (MediaQuery.of(context).size.width) * 0.92,
      height: 100,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
    ));
  }
}
