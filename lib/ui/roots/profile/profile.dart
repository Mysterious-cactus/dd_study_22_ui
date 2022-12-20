import 'package:dd_study_22_ui/ui/roots/profile/profile_view_model.dart';
import 'package:dd_study_22_ui/ui/roots/settings.dart';
import 'package:flutter/material.dart';
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
        Column(children: [
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: [
                        viewModel.avatar == null
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                                minRadius: screenHeight * 0.09,
                                backgroundImage: viewModel.avatar?.image,
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
                                            color: Color.fromARGB(
                                                255, 65, 28, 130),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 40)),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(
                                      Icons.language,
                                      //color: Color.fromARGB(255, 0, 117, 201),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 3)),
                                    viewModel.user!.region != null
                                        ? Text(
                                            viewModel.user!.region ?? "",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 65, 28, 130),
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Row(),
                                    const Text(""),
                                  ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_city,
                                          //color:
                                          //  Color.fromARGB(255, 0, 117, 201),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(left: 3)),
                                        viewModel.user!.city != null
                                            ? Text(
                                                viewModel.user!.city ?? "",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 65, 28, 130),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Row()
                                      ]),
                                ]),
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
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                            color: Color.fromARGB(
                                                255, 65, 28, 130),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: viewModel.changePhoto,
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo,
                                          color: Colors.deepPurple),
                                      title: const Text(
                                        "Open avatar in full screen",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 65, 28, 130),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        //Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.edit_note,
                                          color: Colors.deepPurple),
                                      title: const Text(
                                        "Edit profile",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 65, 28, 130),
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
                      const Text("0",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 117, 201),
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.people,
                            //color: Color.fromARGB(255, 0, 117, 201),
                          )),
                      const Padding(padding: EdgeInsets.only(left: 20)),
                      const Text("0",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 117, 201),
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person_add_alt_1),
                        //color: Color.fromARGB(255, 0, 117, 201)),
                      ),
                    ],
                  )))
        ]),
      ]),
      bottomNavigationBar: BottomAppBar(
        //color: Color.fromARGB(255, 0, 117, 201),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            //vertical: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.newspaper,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              const Spacer(flex: 2),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              const Spacer(flex: 2),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              const Spacer(flex: 2),
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  static create(BuildContext bc) {
    return ChangeNotifierProvider(
      create: (context) {
        return ProfileViewModel(context: bc);
      },
      child: const Profile(),
    );
  }
}
