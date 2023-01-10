import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/roots/app.dart';
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

  List<User> _showedUsers = [];
  List<User> get showedUsers => _showedUsers;
  set showedUsers(List<User> val) {
    _showedUsers = val;
    notifyListeners();
  }

  //List<User> allUsers = [];

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    allUsers = await _api.getUsers();
    if (allUsers != null) {
      showedUsers = allUsers!;
    }
  }

  Future subscribe(String onWhom) async {
    if (user!.subscriptions != null) {
      user!.subscriptions!.add(onWhom);
      await _api.subscribe(onWhom);
    }
  }

  Future unSubscribe(String fromWhom) async {
    if (user!.subscriptions != null) {
      user!.subscriptions!.remove(fromWhom);
      await _api.unSubscribe(fromWhom);
    }
  }

  bool checkSubscription(String onWhom) {
    if (user!.subscriptions != null) {
      return user!.subscriptions!.contains(onWhom);
    } else {
      return false;
    }
  }

  void search(String str) {
    if (allUsers != null) {
      if (str.isNotEmpty) {
        showedUsers = [];
        for (var user in allUsers!) {
          if (user.name.contains(str)) {
            showedUsers.add(user);
          }
        }
      } else {
        showedUsers = allUsers!;
      }
    }
  }
}

class _Search extends StatefulWidget {
  const _Search({
    Key? key,
  }) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<_Search> {
  String text = " ";
  bool updated = false;
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var appModel = context.watch<AppViewModel>();
    updated = false;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: SafeArea(
          child: ListView(children: [
        TextField(
          onChanged: viewModel.search,
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
        (viewModel.showedUsers.isNotEmpty)
            ? ListView.separated(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (listContext, listIndex) {
                  Widget res;
                  var user = viewModel.showedUsers[listIndex];
                  bool check = viewModel.checkSubscription(user.id);
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
                          flex: 7,
                          child: Row(children: [
                            CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "$avatarUrl${user.avatarLink}")),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              user.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 65, 28, 130),
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  child: Text((updated)
                                      ? text
                                      : (check ? "Unfollow" : "Follow")),
                                  onPressed: () {
                                    if (check) {
                                      viewModel.unSubscribe(
                                          viewModel.showedUsers[listIndex].id);
                                      setState(() {
                                        text = "Follow";
                                      });
                                      updated = true;
                                      appModel.getPosts();
                                    } else {
                                      viewModel.subscribe(
                                          viewModel.showedUsers[listIndex].id);
                                      setState(() {
                                        text = "Unfollow";
                                      });
                                      updated = true;
                                      appModel.getPosts();
                                    }
                                  },
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
                itemCount: viewModel.showedUsers.length,
              )
            : (viewModel.state.search != null)
                ? const Center(
                    child: Text("No users found... ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 65, 28, 130),
                            fontWeight: FontWeight.bold)))
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ])),
    ));
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
        create: (context) => _ViewModel(context: context),
        child: const _Search(),
      );
}
