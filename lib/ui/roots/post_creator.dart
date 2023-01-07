import 'dart:io';

import 'package:dd_study_22_ui/data/services/auth_service.dart';
import 'package:dd_study_22_ui/data/services/create_post_service.dart';
import 'package:dd_study_22_ui/domain/models/attach_meta.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/common/cam_widget.dart';
import 'package:dd_study_22_ui/ui/extensions/snack_bar_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class _PostCreator extends StatefulWidget {
  const _PostCreator({
    Key? key,
  }) : super(key: key);

  @override
  PostCreatorState createState() => PostCreatorState();
}

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

  void addImageToList(var image) {
    _imageFiles.add(image);
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
  List<Image> _imageFiles = [];

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
              addImageToList(Image.file(file));
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

  final _picker = ImagePicker();

  Future addPictureFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      var t = await _api.uploadTemp(files: [File(pickedFile.path)]);
      if (t.isNotEmpty) {
        _images.add(t.first);
        addImageToList(Image.file(File(pickedFile.path)));
      }
    } else {
      context.removeAndShowSnackbar("No picture selected");
    }
  }
}

class PostCreatorState extends State<_PostCreator> {
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("New Post"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () => viewModel.createPost(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        child: ListView(children: [
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
          (viewModel._imageFiles.isEmpty)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("No attachments added",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 65, 28, 130),
                                  fontWeight: FontWeight.bold)),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Icon(Icons.add_to_photos_outlined)
                        ])
                  ],
                )
              : //Column(children: [
              ListView.separated(
                  //controller: viewModel._lvc,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (listContext, listIndex) {
                    Widget res;
                    //var images = viewModel._imageFiles;
                    res = AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.center,
                          image: viewModel._imageFiles[listIndex].image,
                        ))));
                    return res;
                  },
                  separatorBuilder: (context, index) =>
                      const Padding(padding: EdgeInsets.only(top: 10)),
                  itemCount: viewModel._imageFiles.length,
                ),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BottomAppBar(
          notchMargin: 6,
          shape: const CircularNotchedRectangle(),
          //color: Colors.deepPurple[100],
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  viewModel.addPhotos();
                  //refreshAttachs(viewModel._images.length);
                },
                color: Colors.white,
                icon: const Icon(Icons.photo_camera),
              ),
              IconButton(
                color: Colors.white,
                onPressed: () {
                  viewModel.addPictureFromGallery();
                  //refreshAttachs(viewModel._images.length);
                },
                icon: const Icon(Icons.photo),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static create(BuildContext bc) {
    return ChangeNotifierProvider(
      create: (context) {
        return _ViewModel(context: bc);
      },
      child: const _PostCreator(),
    );
  }
}
