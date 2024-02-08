import 'package:flutter/material.dart';

class HomeFloatingButton extends StatelessWidget {
  final bool showFAB;
  final ScrollController scrollController;
  const HomeFloatingButton({Key? key, required this.showFAB, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: showFAB ? 0.6 : 0.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
          },
          child: Icon(Icons.arrow_upward),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
