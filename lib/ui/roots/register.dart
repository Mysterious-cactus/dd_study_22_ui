import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/create_user_service.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? name;
  final String? email;
  final DateTime? birthday;
  final String? password;
  final String? tryPassword;
  final String? errorText;
  const _ViewModelState({
    this.name,
    this.email,
    this.birthday,
    this.password,
    this.tryPassword,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? name,
    String? email,
    DateTime? birthday,
    String? password,
    String? tryPassword,
    String? errorText,
  }) {
    return _ViewModelState(
      name: name ?? this.name,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      password: password ?? this.password,
      tryPassword: tryPassword ?? this.tryPassword,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var nameTec = TextEditingController();
  var emailTec = TextEditingController();
  var birthTec = TextEditingController();
  var passwTec = TextEditingController();
  var tryPasswTec = TextEditingController();
  final _createUserService = CreateUserService();

  var _date = TextEditingController();
  //final _authService = AuthService();

  BuildContext context;
  _ViewModel({required this.context}) {
    nameTec.addListener(() {
      state = state.copyWith(name: nameTec.text);
    });
    emailTec.addListener(() {
      state = state.copyWith(email: emailTec.text);
    });
    //birthTec.addListener(() {
    //state = state.copyWith(birthday: DateTime.now());
    //});
    state = state.copyWith(birthday: DateTime.now());
    passwTec.addListener(() {
      state = state.copyWith(password: passwTec.text);
    });
    tryPasswTec.addListener(() {
      state = state.copyWith(tryPassword: tryPasswTec.text);
    });
  }

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkFields() {
    return (state.name?.isNotEmpty ?? false) &&
        (state.password?.isNotEmpty ?? false) &&
        (state.email?.isNotEmpty ?? false) &&
        //(state.birthday?.toString().isNotEmpty ?? false) &&
        (state.tryPassword?.isNotEmpty ?? false);
    //(state.tryPassword == state.password);
  }

  void register() async {
    try {
      await _createUserService
          .registerUser(state.name, state.email, DateTime.now(), state.password,
              state.tryPassword)
          .then((value) {
        AppNavigator.toAuth();
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on WrongCredentionalException {
      state = state.copyWith(errorText: "не правильный логин или пароль");
    } on ServerException {
      state = state.copyWith(errorText: "произошла ошибка на сервере");
    }
  }

  DateTime selectedDate = DateTime.now();

  Future _selectDate(BuildContext context) async {
    DateFormat formatter = DateFormat('dd/mm/yyyy');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2020));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _date.value = TextEditingValue(text: formatter.format(picked));
    }
  }
}

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = _ViewModel(context: context);
    return Scaffold(
      appBar: AppBar(
        leading:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
          IconButton(
            onPressed: AppNavigator.toAuth,
            icon: Icon(Icons.arrow_back),
          ),
        ]),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                controller: viewModel.nameTec,
                decoration: const InputDecoration(hintText: "Enter Name"),
              ),
              TextField(
                  controller: viewModel.emailTec,
                  decoration: const InputDecoration(hintText: "Enter Email")),
              //GestureDetector(
              //  onTap: () => viewModel._selectDate(context),
              //  child:
              InputDatePickerFormField(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1901, 1),
                  lastDate: DateTime(2023, 1)),
              TextField(
                  controller: viewModel.passwTec,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Enter Password")),
              TextField(
                  controller: viewModel.tryPasswTec,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Retry Password")),
              const Padding(padding: EdgeInsets.only(top: 10)),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: ElevatedButton(
                    onPressed: viewModel.register,
                    child: const Text("Create account")),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Register(),
      );
}
