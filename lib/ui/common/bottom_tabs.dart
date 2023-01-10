import 'package:dd_study_22_ui/domain/enums/tab_item.dart';
import 'package:dd_study_22_ui/ui/roots/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomTabs extends StatelessWidget {
  final TabItemEnum currentTab;
  final ValueChanged<TabItemEnum> onSelectTab;
  const BottomTabs(
      {Key? key, required this.currentTab, required this.onSelectTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appModel = context.watch<AppViewModel>();
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.transparent,
      type: BottomNavigationBarType.fixed,
      currentIndex: TabItemEnum.values.indexOf(currentTab),
      items: TabItemEnum.values.map((e) => _buildItem(e, appModel)).toList(),
      onTap: (value) {
        FocusScope.of(context).unfocus();
        onSelectTab(TabItemEnum.values[value]);
      },
    );
  }

  BottomNavigationBarItem _buildItem(
      TabItemEnum tabItem, AppViewModel appmodel) {
    var isCurrent = currentTab == tabItem;
    var color =
        isCurrent ? const Color.fromARGB(255, 163, 142, 202) : Colors.white;
    Widget icon = Padding(
        padding: (tabItem.index < 2)
            ? const EdgeInsets.only(right: 30)
            : const EdgeInsets.only(left: 30),
        child: Icon(
          TabEnums.tabIcon[tabItem],
          color: color,
          size: 25,
        ));
    return BottomNavigationBarItem(
        label: "", backgroundColor: Colors.white, icon: icon);
  }
}
