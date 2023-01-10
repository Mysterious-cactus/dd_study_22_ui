import 'package:dd_study_22_ui/ui/roots/tab_events/events.dart';
import 'package:dd_study_22_ui/ui/roots/tab_profile/profile/profile.dart';
import 'package:dd_study_22_ui/ui/roots/tab_search/search.dart';
import 'package:dd_study_22_ui/ui/roots/tab_home/home.dart';
import 'package:flutter/material.dart';

enum TabItemEnum { home, search, events, profile }

class TabEnums {
  static const TabItemEnum defTab = TabItemEnum.home;

  static Map<TabItemEnum, IconData> tabIcon = {
    TabItemEnum.home: Icons.newspaper_outlined,
    TabItemEnum.search: Icons.search_outlined,
    TabItemEnum.events: Icons.notifications,
    TabItemEnum.profile: Icons.person,
  };

  static Map<TabItemEnum, Widget> tabRoots = {
    TabItemEnum.home: Home.create(),
    TabItemEnum.profile: Profile.create(),
    TabItemEnum.events: Events.create(),
    TabItemEnum.search: SearchState.create()
  };
}
