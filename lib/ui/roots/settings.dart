import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../data/services/auth_service.dart';
import '../../domain/models/user.dart';
import '../../internal/config/shared_prefs.dart';
import '../../internal/config/token_storage.dart';
import '../navigation/app_navigator.dart';

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

  Future _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }
}

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = _ViewModel(context: context);
    return Scaffold(
        appBar: AppBar(title: const Text("Settings"), actions: []),
        body: ListView(children: [
          const Padding(padding: EdgeInsets.only(top: 2)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0),
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.white),
            onPressed: viewModel._logout,
            child: Row(
              children: [
                IconButton(
                    color: Colors.deepPurple,
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: viewModel._logout),
                const Padding(padding: EdgeInsets.only(left: 4)),
                const Text("Exit",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 65, 28, 130),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ]));
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Settings(),
    );
  }
}
