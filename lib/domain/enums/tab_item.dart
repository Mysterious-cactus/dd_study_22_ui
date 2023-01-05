import 'package:dd_study_22_ui/ui/roots/profile/profile.dart';
import 'package:dd_study_22_ui/ui/roots/search.dart';
import 'package:dd_study_22_ui/ui/roots/tab_home/home.dart';
import 'package:flutter/material.dart';

enum TabItemEnum { News, Search, Events, Profile }

class TabEnums {
  static const TabItemEnum defTab = TabItemEnum.News;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.News: Icons.newspaper_outlined,
    TabItemEnum.Search: Icons.search_outlined,
    TabItemEnum.Events: Icons.notifications,
    TabItemEnum.Profile: Icons.person,
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.News: Home.create(),
    TabItemEnum.Profile: Profile.create(),
    TabItemEnum.Search: SearchState.create()
  };
}
