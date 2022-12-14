import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/extensions/snack_bar_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  final String? errorText;
  const _ViewModelState({
    this.login,
    this.password,
    this.isLoading = false,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var loginTec = TextEditingController();
  var passwTec = TextEditingController();
  final _authService = AuthService();

  BuildContext context;
  _ViewModel({required this.context}) {
    loginTec.addListener(() {
      state = state.copyWith(login: loginTec.text);
    });
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
  }

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return (state.login?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false);
  }

  void login() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.auth(state.login, state.password).then((value) {
        AppNavigator.toLoader()
            .then((value) => {state = state.copyWith(isLoading: false)});
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "Нет сети");
      context.removeAndShowSnackbar(state.errorText!);
    } on WrongCredentionalException {
      state = state.copyWith(errorText: "Неправильный логин или пароль");
      context.removeAndShowSnackbar(state.errorText!);
    } on ServerException {
      state = state.copyWith(errorText: "Произошла ошибка на сервере");
      context.removeAndShowSnackbar(state.errorText!);
    }
  }
}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sign In",
                    style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 65, 28, 130),
                        fontWeight: FontWeight.bold)),
                TextField(
                  controller: viewModel.loginTec,
                  decoration: const InputDecoration(hintText: "Enter Login"),
                ),
                TextField(
                    controller: viewModel.passwTec,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: "Enter Password")),
                const Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: ElevatedButton(
                      onPressed:
                          viewModel.checkFields() ? viewModel.login : null,
                      child: const Text("Login")),
                ),
                const Padding(padding: EdgeInsets.only(top: 50)),
                GestureDetector(
                  child: const Text("Don't have an account yet? Sign up",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 65, 28, 130),
                        decoration: TextDecoration.underline,
                      )),
                  onTap: AppNavigator.toRegister,
                ),
                if (viewModel.state.isLoading)
                  const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Auth(),
      );
}
