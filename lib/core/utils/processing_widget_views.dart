

import 'package:flutter/material.dart';

class ProcessingWidgetViews{

  

  Widget buildLoadingView() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );

  Widget buildErrorView(String message) => Scaffold(
        body: Center(child: Text(message)),
      );
}