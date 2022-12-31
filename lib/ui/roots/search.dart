import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? search;
  final String? errorText;

  const _ViewModelState({
    this.search,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? search,
    String? errorText,
  }) {
    return _ViewModelState(
      search: search ?? this.search,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var searchTec = TextEditingController();
  final _api = RepositoryModule.apiRepository();
  BuildContext context;
  _ViewModel({required this.context}) {
    asyncInit();
    searchTec.addListener(() {
      state = state.copyWith(search: searchTec.text);
    });
  }

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  List<User>? _allUsers;
  List<User>? get allUsers => _allUsers;
  set allUsers(List<User>? val) {
    _allUsers = val;
    notifyListeners();
  }

  //List<User> allUsers = [];

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    allUsers = await _api.getUsers();
  }
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: SafeArea(
          child: ListView(children: [
        TextField(
          controller: viewModel.searchTec,
          textAlignVertical: const TextAlignVertical(y: 1),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.deepPurple[50],
            hintText: "Search...",
            prefixIcon: const Icon(Icons.search),
            constraints: const BoxConstraints(maxHeight: 40),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        (viewModel._allUsers != null)
            ? ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (listContext, listIndex) {
                  Widget res;
                  res = Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        )),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Row(children: [
                            CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "$avatarUrl${viewModel._allUsers![listIndex].avatarLink}")),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              viewModel._allUsers![listIndex].name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 65, 28, 130),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        Expanded(
                          flex: 5,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: const Text("Follow"),
                                  onPressed: () {},
                                ),
                              ]),
                        ),
                      ],
                    ),
                  );
                  return res;
                },
                separatorBuilder: (context, index) =>
                    const Padding(padding: EdgeInsets.only(top: 10)),
                itemCount: viewModel.allUsers!.length,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ])),
    ));
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const Search(),
      );
}
