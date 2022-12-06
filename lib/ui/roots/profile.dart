import 'package:dd_study_22_ui/ui/roots/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dd_study_22_ui/ui/roots/app.dart';
import '../../data/services/auth_service.dart';
import '../../domain/models/user.dart';
import '../../internal/config/app_config.dart';
import '../../internal/config/shared_prefs.dart';
import '../../internal/config/token_storage.dart';

class Profile extends StatelessWidget {
  ViewModel? viewModel;
  Profile({ViewModel? model, Key? key}) : super(key: key) {
    viewModel = model;
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 117, 201),
          title: const Text("Your profile"),
          actions: [
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                })
          ]),
      body: ListView(children: [
        Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 206, 239, 255),
                  border: Border.all(color: Colors.lightBlue, width: 1),
                  borderRadius: const BorderRadius.all(
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
                        (viewModel!.user != null && viewModel!.headers != null)
                            ? CircleAvatar(
                                minRadius: screenHeight * 0.1,
                                backgroundImage: NetworkImage(
                                    "$avatarUrl${viewModel!.user!.avatarLink}",
                                    headers: viewModel!.headers))
                            : Row()
                      ]),
                      Padding(padding: const EdgeInsets.only(left: 10)),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        viewModel!.user == null
                                            ? "Your profile"
                                            : viewModel!.user!.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Color.fromARGB(
                                                255, 0, 117, 201),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            Padding(padding: const EdgeInsets.only(top: 40)),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(
                                      Icons.language,
                                      color: Color.fromARGB(255, 0, 117, 201),
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3)),
                                    viewModel!.user!.region != null
                                        ? Text(
                                            viewModel!.user!.region!,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 0, 117, 201),
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Row(),
                                    Text(""),
                                  ]),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_city,
                                          color:
                                              Color.fromARGB(255, 0, 117, 201),
                                        ),
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3)),
                                        viewModel!.user!.city != null
                                            ? Text(
                                                viewModel!.user!.city!,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        255, 0, 117, 201),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Row()
                                      ]),
                                ]),
                          ])
                    ]),
              )),
          Padding(padding: const EdgeInsets.only(top: 2)),
          Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 206, 239, 255),
                  border: Border.all(color: Colors.lightBlue, width: 1),
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
                          side: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 0, 117, 201))),
                      onPressed: () {},
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit),
                            Padding(padding: EdgeInsets.only(left: 2)),
                            Text("Редактировать",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                          ]),
                    )),
                //]),
              ])),
          Padding(padding: const EdgeInsets.only(top: 2)),
          Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 206, 239, 255),
                  border: Border.all(color: Colors.lightBlue, width: 1),
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
                      Text("0",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 117, 201),
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.people,
                            color: Color.fromARGB(255, 0, 117, 201),
                          )),
                      Padding(padding: const EdgeInsets.only(left: 20)),
                      Text("0",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 117, 201),
                              fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.person_add_alt_1),
                          color: Color.fromARGB(255, 0, 117, 201)),
                    ],
                  )))
        ]),
      ]),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 0, 117, 201),
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

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ViewModel(context: context),
      child: Profile(),
    );
  }
}
