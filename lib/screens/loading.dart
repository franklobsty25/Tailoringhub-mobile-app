import 'package:flutter/material.dart';
import 'package:argon_flutter/constants/Theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage("assets/img/tailoringhub.jpg"),
                  fit: BoxFit.cover)),
          child: Center(
            child: const SpinKitFadingCircle(
              color: ArgonColors.primary,
              size: 50.0,
            ),
          ),
        ),
      ],
    );
  }
}
