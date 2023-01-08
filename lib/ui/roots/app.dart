import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/profile_post_model.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/common/bottom_tabs.dart';
import 'package:dd_study_22_ui/ui/navigation/tab_navigator.dart';
import 'package:dd_study_22_ui/ui/roots/post_creator.dart';
import 'package:dd_study_22_ui/ui/roots/post_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../domain/enums/tab_item.dart';
import '../../../domain/models/user.dart';
import '../../../internal/config/app_config.dart';
import '../../../internal/config/shared_prefs.dart';

class AppViewModel extends ChangeNotifier {
  BuildContext context;
  final _api = RepositoryModule.apiRepository();
  final _dataService = DataService();
  AppViewModel({required this.context}) {
    asyncInit();
  }

  final _navigationKeys = {
    TabItemEnum.News: GlobalKey<NavigatorState>(),
    TabItemEnum.Search: GlobalKey<NavigatorState>(),
    TabItemEnum.Events: GlobalKey<NavigatorState>(),
    TabItemEnum.Profile: GlobalKey<NavigatorState>(),
  };

  var _currentTab = TabEnums.defTab;
  TabItemEnum? beforeTab;
  TabItemEnum get currentTab => _currentTab;
  void selectTab(TabItemEnum tabItemEnum) {
    if (tabItemEnum == _currentTab) {
      _navigationKeys[tabItemEnum]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      beforeTab = _currentTab;
      _currentTab = tabItemEnum;
      notifyListeners();
    }
  }

  User? _user;
  User? get user => _user;
  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  List<PostModel>? _posts;
  List<PostModel>? get posts => _posts;
  set posts(List<PostModel>? val) {
    _posts = val;
    notifyListeners();
  }

  List<ProfilePostModel>? _currentPosts;
  List<ProfilePostModel>? get currentPosts => _currentPosts;
  set currentPosts(List<ProfilePostModel>? val) {
    _currentPosts = val;
    notifyListeners();
  }

  Image? _avatar;
  Image? get avatar => _avatar;
  set avatar(Image? val) {
    _avatar = val;
    notifyListeners();
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
    //var img =
    //    await NetworkAssetBundle(Uri.parse("$avatarUrl${user!.avatarLink}"))
    //        .load("$avatarUrl${user!.avatarLink}?v=1");
    //avatar = Image.memory(
    //  img.buffer.asUint8List(),
    //  fit: BoxFit.fill,
    //);
    //getPosts();
    //getCurrentUserPosts();
    avatar = Image.network("$avatarUrl${user!.avatarLink}");
  }

  void getPosts() async {
    try {
      await SyncService().syncPosts();
      posts = await _dataService.getPosts();
    } on DioError {
      posts = null;
    }
  }

  void getCurrentUserPosts() async {
    try {
      currentPosts = await _api.getCurrentUserPosts();
    } on DioError {
      currentPosts = null;
    }
  }

  void addLikeToPost(String? postId) async {
    if (postId != null) {
      await _api.addLikeToPost(postId);
    }
  }

  void removeLikeFromPost(String? postId) async {
    if (postId != null) {
      await _api.removeLikeFromPost(postId);
    }
  }

  void toPostCreator(BuildContext bc) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => PostCreatorState.create(bc)));
  }

  void toPostDetail(String? postId) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (__) => PostDetail.create(postId)));
  }
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  bool updated = false;
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<AppViewModel>();
    if (!updated) {
      viewModel.getPosts();
      updated = true;
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
          onWillPop: () async {
            var isFirstRouteInCurrentTab = !await viewModel
                ._navigationKeys[viewModel.currentTab]!.currentState!
                .maybePop();
            if (isFirstRouteInCurrentTab) {
              if (viewModel.currentTab != TabEnums.defTab) {
                viewModel.selectTab(TabEnums.defTab);
              }
              return false;
            }
            return isFirstRouteInCurrentTab;
          },
          child: Scaffold(
            extendBody: true,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FittedBox(
              child: FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed: () => viewModel.toPostCreator(context),
                child: const Icon(Icons.add),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 6,
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: BottomTabs(
                    currentTab: viewModel.currentTab,
                    onSelectTab: viewModel.selectTab,
                  )),
            ),
            body: Stack(
                children: TabItemEnum.values
                    .map((e) => _buildOffstageNavigator(context, e))
                    .toList()),
          )),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AppViewModel(context: context),
      child: App(),
    );
  }

  Widget _buildOffstageNavigator(BuildContext context, TabItemEnum tabItem) {
    var viewModel = context.watch<AppViewModel>();

    return Offstage(
      offstage: viewModel.currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: viewModel._navigationKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }
}
