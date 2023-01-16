import 'package:flutter/material.dart';

class HomePageLoadingWidget extends StatelessWidget {
  const HomePageLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0
        ),
        itemBuilder: (BuildContext context, int index){
          return Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(16)
            ),
          );
        },
      ),
    );
  }
}
