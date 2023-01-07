import 'package:dd_study_22_ui/data/services/data_service.dart';
import 'package:dd_study_22_ui/data/services/sync_service.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/ui/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _dataService = DataService();
  //final _lvc = ScrollController();
  var appmodel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  _ViewModel({required this.context}) {
    asyncInit();

    /*_lvc.addListener(() {
      var max = _lvc.position.maxScrollExtent;
      var current = _lvc.offset;
      var percent = (current / max * 100);
      if (percent > 80) {
        if (!isLoading) {
          isLoading = true;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            appmodel.posts = <PostModel>[
              ...appmodel.posts!,
              ...appmodel.posts!
            ];
            isLoading = false;
          });
        }
      }
    });*/
  }

  User? _user;
  User? get user => _user;

  set user(User? val) {
    _user = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};

  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  Map<String, String>? headers;

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
  }

  /*void obclick() {
    var offset = _lvc.offset;

    _lvc.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeInCubic);
  }*/

  void toPostDetail(String? postId) {
    appmodel.toPostDetail(postId);
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    viewModel.appmodel = context.watch<AppViewModel>();
    viewModel.appmodel.getPosts();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var itemCount = viewModel.appmodel.posts?.length ?? 0;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(255, 0, 117, 201),
        leading: (viewModel.appmodel.avatar != null)
            ? Row(children: [
                const Spacer(),
                CircleAvatar(
                  backgroundImage: viewModel.appmodel.avatar?.image,
                )
              ])
            : null,
        title: Text(viewModel.user == null ? "Hi" : viewModel.user!.name),
      ),
      body: Container(
          child: viewModel.appmodel.posts == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    (viewModel.appmodel.posts!.isEmpty)
                        ? Expanded(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Nothing to show...",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(
                                                255, 65, 28, 130),
                                            fontWeight: FontWeight.bold)),
                                    Padding(padding: EdgeInsets.only(left: 10)),
                                    Icon(Icons.photo_library_outlined)
                                  ])
                            ],
                          ))
                        : Expanded(
                            child: ListView.separated(
                            //controller: viewModel._lvc,
                            itemBuilder: (listContext, listIndex) {
                              Widget res;
                              var posts = viewModel.appmodel.posts;
                              if (posts != null) {
                                var post = posts[listIndex];
                                res = GestureDetector(
                                  onTap: () => viewModel.toPostDetail(post.id),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        //border: Border.all(width: 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        )),
                                    padding: const EdgeInsets.all(10),
                                    height: screenWidth,
                                    child: Column(
                                      children: [
                                        Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.deepPurple,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                clipBehavior: Clip.hardEdge,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      "$avatarUrl${post.author.avatarLink}"),
                                                ),
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10)),
                                              Text(
                                                post.author.name,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 65, 28, 130),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ]),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        Expanded(
                                          child: PageView.builder(
                                            onPageChanged: (value) =>
                                                viewModel.onPageChanged(
                                                    listIndex, value),
                                            itemCount: post.contents.length,
                                            itemBuilder:
                                                (pageContext, pageIndex) =>
                                                    Container(
                                              //color: Colors.yellow,
                                              child: Image(
                                                  image: NetworkImage(
                                                "$avatarUrl${post.contents[pageIndex].contentLink}",
                                              )),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        PageIndicator(
                                          count: post.contents.length,
                                          current: viewModel.pager[listIndex],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                post.description ?? "",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Color.fromARGB(
                                                        255, 65, 28, 130),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        const Divider(
                                          color: Colors.deepPurple,
                                          thickness: 1,
                                          height: 1,
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.05,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(Icons
                                                        .favorite_outline)),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(Icons
                                                        .comment_outlined)),
                                                Text(
                                                  (post.comments != null
                                                          ? post
                                                              .comments!.length
                                                          : 0)
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color.fromARGB(
                                                          255, 65, 28, 130),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                res = const SizedBox.shrink();
                              }
                              return res;
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: itemCount,
                          )),
                    if (viewModel.isLoading) const LinearProgressIndicator()
                  ],
                )),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => _ViewModel(context: context),
      child: const Home(),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int count;
  final int? current;
  final double width;
  const PageIndicator(
      {Key? key, required this.count, required this.current, this.width = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < count; i++) {
      widgets.add(
        Icon(
          Icons.circle,
          size: i == (current ?? 0) ? width * 1.4 : width,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [...widgets],
    );
  }
}
