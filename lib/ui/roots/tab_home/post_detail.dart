import 'package:dd_study_22_ui/domain/models/comment_model.dart';
import 'package:dd_study_22_ui/domain/models/post_model.dart';
import 'package:dd_study_22_ui/domain/models/user.dart';
import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/internal/config/shared_prefs.dart';
import 'package:dd_study_22_ui/internal/dependencies/repository_module.dart';
import 'package:dd_study_22_ui/ui/roots/tab_home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ViewModelState {
  final String? comment;

  const _ViewModelState({
    this.comment,
  });

  _ViewModelState copyWith({
    String? comment,
  }) {
    return _ViewModelState(
      comment: comment ?? this.comment,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _api = RepositoryModule.apiRepository();
  final String? postId;
  var commentTec = TextEditingController();

  _ViewModel({required this.context, this.postId}) {
    asyncInit();
    getPostById();
    commentTec.addListener(() {
      state = state.copyWith(comment: commentTec.text);
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

  PostModel? _post;
  PostModel? get post => _post;
  set post(PostModel? val) {
    _post = val;
    notifyListeners();
  }

  Map<int, int> pager = <int, int>{};
  void onPageChanged(int listIndex, int pageIndex) {
    pager[listIndex] = pageIndex;
    notifyListeners();
  }

  void asyncInit() async {
    user = await SharedPrefs.getStoredUser();
  }

  Future getPostById() async {
    if (postId != null) {
      post = await _api.getPostById(postId!);
    }
  }

  void addComment() async {
    if (postId != null) {
      await _api.createComment(
          CommentModel(commentText: state.comment!, postId: postId!));
      getPostById();
    }
  }

  bool checkFields() {
    return (state.comment?.isNotEmpty ?? false);
  }
}

class PostDetail extends StatelessWidget {
  const PostDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post"),
      ),
      body: ListView(
        children: [
          (viewModel.post != null)
              ? Container(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.deepPurple, width: 2),
                                  borderRadius: BorderRadius.circular(100)),
                              clipBehavior: Clip.hardEdge,
                              child: CircleAvatar(
                                backgroundImage:
                                    viewModel.post!.author.avatarLink != null
                                        ? NetworkImage(avatarUrl +
                                            viewModel.post!.author.avatarLink!)
                                        : null,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              viewModel.post!.author.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 65, 28, 130),
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Expanded(
                        child: PageView.builder(
                          onPageChanged: (value) =>
                              viewModel.onPageChanged(0, value),
                          itemCount: viewModel.post!.contents.length,
                          itemBuilder: (pageContext, pageIndex) => Container(
                            //color: Colors.yellow,
                            child: Image(
                                image: NetworkImage(
                              "$avatarUrl${viewModel.post!.contents[pageIndex].contentLink}",
                            )),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      PageIndicator(
                        count: viewModel.post!.contents.length,
                        current: viewModel.pager[0],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15),
                        child: Row(
                          children: [
                            Text(
                              viewModel.post!.description ?? "",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 65, 28, 130),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      const Divider(
                        color: Colors.deepPurple,
                        thickness: 1,
                        height: 1,
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite_outline)),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.comment_outlined),
                              ),
                              //const Padding(padding: EdgeInsets.only(left: 2)),
                              Text(
                                (viewModel.post!.comments != null
                                        ? viewModel.post!.comments!.length
                                        : 0)
                                    .toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 65, 28, 130),
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                    ],
                  ),
                )
              : Container(),
          const Padding(padding: EdgeInsets.only(top: 10)),
          (viewModel.post != null && viewModel.post!.comments != null)
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
                                      "$avatarUrl${viewModel.post!.comments![listIndex].author.avatarLink}")),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel
                                        .post!.comments![listIndex].author.name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 65, 28, 130),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  Text(
                                    viewModel
                                        .post!.comments![listIndex].commentText,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color.fromARGB(255, 65, 28, 130),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ]),
                          ),
                        ],
                      ),
                    );

                    return res;
                  },
                  separatorBuilder: (context, index) =>
                      const Padding(padding: EdgeInsets.only(top: 1)),
                  itemCount: viewModel.post!.comments!.length,
                )
              : Container(),
        ],
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
              Expanded(
                child: TextField(
                    //onChanged: viewModel.search,
                    controller: viewModel.commentTec,
                    textAlignVertical: const TextAlignVertical(y: 1),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      filled: true,
                      fillColor: Colors.deepPurple[50],
                      hintText: "Comment...",
                      constraints: const BoxConstraints(maxHeight: 40),
                    )),
                flex: 9,
              ),
              Expanded(
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      if (viewModel.checkFields()) {
                        viewModel.addComment();
                        viewModel.commentTec.text = "";
                        FocusScope.of(context).unfocus();
                      }
                    },
                    icon: const Icon(Icons.send_rounded),
                  ),
                  flex: 1)
            ],
          ),
        ),
      ),
    );
  }

  static create(Object? arg) {
    String? postId;
    if (arg != null && arg is String) postId = arg;
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          _ViewModel(context: context, postId: postId),
      child: const PostDetail(),
    );
  }
}
