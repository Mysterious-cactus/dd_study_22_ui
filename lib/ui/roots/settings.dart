import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../../domain/models/user.dart';
import '../../internal/config/shared_prefs.dart';
import '../../internal/config/token_storage.dart';
import '../app_navigator.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();

  _ViewModel({required this.context}) {
    asyncInit();
  }

  User? _user;

  User? get user => _user;

  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    var token = await TokenStorage.getAccessToken();
    headers = {"Authorization": "Bearer $token"};
    user = await SharedPrefs.getStoredUser();
  }

  void _logout() async {
    await _authService.logout().then((value) => AppNavigator.toLoader());
  }
}

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = new _ViewModel(context: context);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 117, 201),
            title: const Text("Settings"),
            actions: []),
        body: ListView(children: [
          Padding(padding: const EdgeInsets.only(top: 2)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.lightBlue, width: 1),
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Color.fromARGB(255, 206, 239, 255)),
            onPressed: viewModel._logout,
            child: Row(
              children: [
                IconButton(
                    color: Color.fromARGB(255, 0, 117, 201),
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: viewModel._logout),
                Padding(padding: const EdgeInsets.only(left: 4)),
                Text("Exit",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 117, 201),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ]));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: Settings(),
    );
  }
}
