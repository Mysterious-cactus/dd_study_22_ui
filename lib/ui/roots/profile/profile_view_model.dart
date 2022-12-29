import 'dart:io';

import 'package:dd_study_22_ui/domain/models/profile_post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/common/cam_widget.dart';
import 'package:dd_study_22_ui/ui/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final _api = RepositoryModule.apiRepository();
  final BuildContext context;
  ProfileViewModel({required this.context}) {
    asyncInit();
  }
  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Future asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    var img =
        await NetworkAssetBundle(Uri.parse("$avatarUrl${user!.avatarLink}"))
            .load("$avatarUrl${user!.avatarLink}?v=1");
    avatar = Image.memory(
      img.buffer.asUint8List(),
      fit: BoxFit.fill,
    );
    posts = await getPosts();
  }

  String? _imagePath;
  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  List<ProfilePostModel>? _posts;
  List<ProfilePostModel>? get posts => _posts;
  set posts(List<ProfilePostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  Future<List<ProfilePostModel>> getPosts() async {
    var p = await _api.getCurrentUserPosts();
    return p;
  }

  Future changePhoto() async {
    var appmodel = context.read<AppViewModel>();
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
        await _api.addAvatarToUser(t.first);

        var img =
            await NetworkAssetBundle(Uri.parse("$avatarUrl${user!.avatarLink}"))
                .load("$avatarUrl${user!.avatarLink}?v=1");
        var avImage = Image.memory(img.buffer.asUint8List());
        avatar = avImage;
        appmodel.avatar = avImage;
      }
    }
  }
}
