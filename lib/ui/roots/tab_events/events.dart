import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  _ViewModel({required this.context});
}

class Events extends StatelessWidget {
  const Events({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Events(),
    );
  }
}
