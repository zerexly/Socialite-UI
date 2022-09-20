import 'package:flutter/material.dart';
import 'package:foap/components/media_selector/picker_decoration.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, required this.decoration}) : super(key: key);

  final PickerDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (decoration.loadingWidget != null)
          ? decoration.loadingWidget
          : const CircularProgressIndicator(),
    );
  }
}
