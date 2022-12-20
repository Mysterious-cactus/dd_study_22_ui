import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/createPostService.dart';
import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/app_navigator.dart';
import 'package:dd_study_22_ui/ui/common/cam_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? description;
  final String? errorText;
  const _ViewModelState({
    this.description,
    this.errorText,
  });

  _ViewModelState copyWith({
    String? description,
    String? errorText,
  }) {
    return _ViewModelState(
      description: description ?? this.description,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  var decriptionTec = TextEditingController();
  final _api = RepositoryModule.apiRepository();
  final _createPostService = CreatePostService();
  final BuildContext context;

  _ViewModel({required this.context}) {
    asyncInit();
    decriptionTec.addListener(() {
      state = state.copyWith(description: decriptionTec.text);
    });
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  var _state = const _ViewModelState();
  _ViewModelState get state => _state;
  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  bool checkField() {
    return (state.description?.isNotEmpty ?? false);
  }

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
  }

  String? _imagePath;
  List<AttachMeta> _images = [];

  Future addPhotos() async {
    //var appmodel = context.read<AppViewModel>();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (newContext) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: SafeArea(
          child: CamWidget(
            onFile: (file) {
              _imagePath = file.path;
              Navigator.of(newContext).pop();
            },
          ),
        ),
      ),
    ));
    if (_imagePath != null) {
      var t = await _api.uploadTemp(files: [File(_imagePath!)]);
      if (t.isNotEmpty) {
        _images.add(t.first);
      }
    }
  }

  void createPost() async {
    try {
      await _createPostService
          .createPost(user!.id, state.description, _images)
          .then((value) {
        AppNavigator.toHome();
      });
    } on NoNetworkException {
      state = state.copyWith(errorText: "нет сети");
    } on ServerException {
      state = state.copyWith(errorText: "произошла ошибка на сервере");
    }
  }
}

class PostCreator extends StatelessWidget {
  const PostCreator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () => viewModel.createPost(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        child: Column(
          children: [
            TextField(
              maxLength: 100,
              maxLines: 6,
              controller: viewModel.decriptionTec,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  hintText: "Description",
                  fillColor: Colors.deepPurple[50]),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple[100],
        child: Row(
          children: [
            IconButton(
              onPressed: viewModel.addPhotos,
              icon: const Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.photo),
            ),
          ],
        ),
      ),
    );
  }

  static create(BuildContext bc) {
    return ChangeNotifierProvider(
      create: (context) {
        return _ViewModel(context: bc);
      },
      child: const PostCreator(),
    );
  }
}
