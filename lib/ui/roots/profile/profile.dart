import 'package:dd_study_22_ui/internal/config/app_config.dart';
import 'package:dd_study_22_ui/ui/roots/tab_home/home.dart';
import 'package:dd_study_22_ui/ui/roots/profile/profile_view_model.dart';
import 'package:dd_study_22_ui/ui/roots/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var viewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Color.fromARGB(255, 0, 117, 201),
          title: const Text("Your profile"),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Settings()));
                })
          ]),
      body: ListView(children: [
        Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                )),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(children: [
                  viewModel.avatar == null
                      ? const CircularProgressIndicator()
                      : Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepPurple, width: 3),
                              borderRadius: BorderRadius.circular(100)),
                          clipBehavior: Clip.hardEdge,
                          child: CircleAvatar(
                              minRadius: screenHeight * 0.09,
                              backgroundImage: viewModel.avatar?.image),
                        ),
                ]),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                  viewModel.user == null
                                      ? "Your profile"
                                      : viewModel.user!.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 65, 28, 130),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 40)),
                      (viewModel.user != null)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(viewModel.user!.birthDate),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 65, 28, 130),
                                          fontWeight: FontWeight.bold)),
                                  (viewModel.user!.region != "empty")
                                      ? Row(children: [
                                          const Icon(
                                            Icons.language,
                                            //color: Color.fromARGB(255, 0, 117, 201),
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3)),
                                          Text(
                                            viewModel.user!.region ?? "",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 65, 28, 130),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ])
                                      : Row(),
                                  (viewModel.user!.city != "empty")
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                              const Icon(
                                                Icons.location_city,
                                                //color:
                                                //  Color.fromARGB(255, 0, 117, 201),
                                              ),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 3)),
                                              Text(
                                                viewModel.user!.city ?? "",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 65, 28, 130),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ])
                                      : Row(),
                                ])
                          : Column(),
                    ])
              ]),
            )),
        const Padding(padding: EdgeInsets.only(top: 4)),
        Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                )),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: screenWidth - 40,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                          width: 1,
                          //color: Color.fromARGB(255, 0, 117, 201))),
                        )),
                    onPressed: () {
                      showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          builder: (context) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.upload,
                                      color: Colors.deepPurple,
                                    ),
                                    title: const Text(
                                      "Change avatar",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 65, 28, 130),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      viewModel.changePhoto();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo,
                                        color: Colors.deepPurple),
                                    title: const Text(
                                      "Open avatar in full screen",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 65, 28, 130),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      //Navigator.pop(context);
                                      //viewModel.getPosts();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.edit_note,
                                        color: Colors.deepPurple),
                                    title: const Text(
                                      "Edit profile",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 65, 28, 130),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      //Navigator.pop(context);
                                    },
                                  ),
                                ]);
                          });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.edit),
                          Padding(padding: EdgeInsets.only(left: 2)),
                          Text("Edit",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ]),
                  )),
              //]),
            ])),
        const Padding(padding: EdgeInsets.only(top: 4)),
        Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                )),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (viewModel.posts == null)
                        ? const Center(child: CircularProgressIndicator())
                        : Column(children: [
                            Text((viewModel.posts!.length).toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 65, 28, 130),
                                    fontWeight: FontWeight.bold)),
                            const Text("Posts",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 65, 28, 130),
                                    fontWeight: FontWeight.bold)),
                          ]),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    Column(children: [
                      Text((viewModel.user?.subscribers?.length).toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 65, 28, 130),
                              fontWeight: FontWeight.bold)),
                      const Text("Followers",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 65, 28, 130),
                              fontWeight: FontWeight.bold)),
                    ]),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    Column(children: [
                      Text((viewModel.user?.subscriptions?.length).toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 65, 28, 130),
                              fontWeight: FontWeight.bold)),
                      const Text("Following",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 65, 28, 130),
                              fontWeight: FontWeight.bold)),
                    ]),
                  ],
                ))),
        const Padding(padding: EdgeInsets.only(top: 4)),
        BottomAppBar(
          child: Row(
            children: const [
              Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text("Posts",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))
            ],
          ),
        ),
        (viewModel.posts == null || viewModel.user == null)
            ? const Center(child: CircularProgressIndicator())
            : //Column(children: [
            ListView.separated(
                //controller: viewModel._lvc,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (listContext, listIndex) {
                  Widget res;
                  viewModel.getPosts();
                  var posts = viewModel.posts;
                  if (posts != null) {
                    var post = posts[listIndex];
                    res = Container(
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
                                    backgroundImage: viewModel.avatar?.image,
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Text(
                                  viewModel.user!.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 65, 28, 130),
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Divider(
                            color: Colors.deepPurple,
                            thickness: 1,
                            height: 1,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Expanded(
                            child: PageView.builder(
                              onPageChanged: (value) =>
                                  viewModel.onPageChanged(listIndex, value),
                              itemCount: post.contents.length,
                              itemBuilder: (pageContext, pageIndex) =>
                                  Container(
                                //color: Colors.yellow,
                                child: Image(
                                    image: NetworkImage(
                                  "$avatarUrl${post.contents[pageIndex].contentLink}",
                                )),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          PageIndicator(
                            count: post.contents.length,
                            current: viewModel.pager[listIndex],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 15),
                            child: Row(
                              children: [
                                Text(
                                  post.description ?? "",
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.favorite_outline)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.comment_outlined))
                                ]),
                          ),
                        ],
                      ),
                    );
                  } else {
                    res = const SizedBox.shrink();
                  }
                  return res;
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount:
                    viewModel.posts == null ? 1 : viewModel.posts!.length,
              ),

        //]),
      ]),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(context: context);
      },
      child: const Profile(),
    );
  }
}
