import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../themes/theme.dart';

class LoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).backgroundColor.withOpacity(1.0),
        child: Center(
          child: SpinKitCircle(
            color: primaryColor,
            size: 70.0,
          ),
        ),
      ),
    );
  }
}