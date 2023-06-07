import 'package:chat_playground/define/mg_handy.dart';
import 'package:chat_playground/models/chatgroup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatTabList extends StatefulWidget {
  const ChatTabList({Key? key}) : super(key: key);

  @override
  State<ChatTabList> createState() => ChatTabListState();
}

class ChatTabListState extends State<ChatTabList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final Color appBarIconsColor = const Color(0xFF212121);
  final Color backgroundColor = const Color(0xFFf0f0f0);

  bool _isEdit = false;
  late ChatGroupNotifier groupNotifier;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    groupNotifier = context.read<ChatGroupNotifier>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('챗 리스트'),
          actions: [
            TextButton(
                child: _isEdit ? const Text('완료') : const Text('편집'),
                onPressed: () => setState(() {
                      _isEdit = !_isEdit;
                    })),
          ],
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.white,
          //triggerMode: RefreshIndicatorTriggerMode.anywhere,
          notificationPredicate: (_) => false,
          backgroundColor: Colors.blue,
          strokeWidth: 4.0,

          onRefresh: () {
            if (isSwapping == true) {
              onSwap(_oldIndex, _newIndex);
              isSwapping = false;
            }
            return Future<void>.sync(() => null);
          },

          // Pull from top to show refresh indicator.
          child: Flex(direction: Axis.vertical, children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: reorderListViewBuild(),
            )),
          ]),
        ));
  }

  // reorderListView() {
  //   return ReorderableListView(
  //     header: _isEdit
  //         ? const Text('위치를 이동하거나 좌우로 지우세요.')
  //         : const Text('이동할 탭을 선택하세요.'),
  //     buildDefaultDragHandles: _isEdit,
  //     children: buildListAll(context),
  //     onReorder: (int oldIndex, int newIndex) {
  //       _oldIndex = oldIndex;
  //       _newIndex = newIndex;
  //       isSwapping = true;
  //       _refreshIndicatorKey.currentState?.show();
  //     },
  //     footer: Column(
  //       children: [
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             onAddTab(context);
  //           },
  //           child: const Text(
  //             '추가하기',
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  reorderListViewBuild() {
    return Selector<ChatGroupNotifier, int>(
        selector: (_, provider) => provider.chatGroupsOrder.length,
        builder: (context, chatGroupsOrderlength, child) {
          return ReorderableListView.builder(
            header: _isEdit
                ? const Text('위치를 이동하거나 좌우로 지우세요')
                : const Text('이동할 탭을 선택하세요.'),
            buildDefaultDragHandles: _isEdit,
            onReorder: (int oldIndex, int newIndex) {
              _oldIndex = oldIndex;
              _newIndex = newIndex;
              isSwapping = true;
              _refreshIndicatorKey.currentState?.show();
            },
            itemCount: chatGroupsOrderlength,
            itemBuilder: (BuildContext context, int index) {
              return buildItem2(context, index);
            },
            footer: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('추가하기'),
                  onPressed: () {
                    onAddTab(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  buildItem2(BuildContext context, int index) {
    var label = groupNotifier.getChatTabLebel(index);
    DateTime? chatdate = groupNotifier.chatTimes[index] ?? DateTime.now();
    var subLabel = DateFormat('yyyy-MM-dd hh:mm').format(chatdate);

    //var groupID = groupNotifier.chatGroupsOrder[index];

    return _isEdit
        ? Container(
            key: Key('$index'),
            child: Dismissible(
                background: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    Icons.delete,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                secondaryBackground: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                key: ValueKey<String>(
                    groupNotifier.chatGroupsOrder[index].toString()),
                onDismissed: (DismissDirection direction) async {
                  //_context = context;
                  //_index = index;
                  //isRemoving = true;
                  _refreshIndicatorKey.currentState?.show();
                  onRemove(context, index);
                  mgLog('Removed');
                },
                confirmDismiss: (direction) => dialogBuilder(context, index),
                child: Card(
                    key: Key('${index + 200}'),
                    child: ListTile(
                      key: Key('$index'),
                      trailing: _isEdit
                          ? ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle))
                          : null,
                      subtitle: Text(subLabel),
                      leading: IconButton(
                        icon: const Icon(
                            Icons.remove_circle_sharp, //Icons.remove_circle,
                            color: Colors.redAccent),
                        onPressed: () {
                          dialogBuilder(context, index).then((value) {
                            if (value != null && value == true) {
                              _refreshIndicatorKey.currentState?.show();
                              onRemove(context, index);
                            }
                          });
                          // 바로 삭제
                          // _refreshIndicatorKey.currentState?.show();
                          // onRemove(context, index);
                        },
                      ),
                      // title: Expanded(
                      //   flex: 8,
                      //   child: Text(label, overflow: TextOverflow.ellipsis),
                      // ),

                      title: Text(label, overflow: TextOverflow.ellipsis),
                    ))))
        : Card(
            key: Key('${index + 200}'),
            child: Selector<ChatGroupNotifier, int>(
                selector: (_, provider) => provider.lastTabIndex,
                builder: (context, lastTabIndex, child) {
                  return RadioListTile<int>(
                      value: index,
                      groupValue: lastTabIndex,
                      key: Key('$index'),
                      subtitle: Text(subLabel),
                      onChanged: (value) {
                        if (value != null) {
                          groupNotifier.setTabIndex(value);
                        }
                      },
                      title: Row(children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(label, overflow: TextOverflow.ellipsis),
                        ),
                      ]));
                }),
          );
  }

  bool isSwapping = false;
  late int _oldIndex;
  late int _newIndex;

  onSwap(int oldIndex, int newIndex) {
    groupNotifier.swapTab(oldIndex, newIndex);
  }

  //bool isRemoving = false;

  onAddTab(BuildContext context) {
    groupNotifier.addTab();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('챗 탭이 추가되었습니다.'),
        action: SnackBarAction(
          label: '확인',
          onPressed: () {},
        ),
      ),
    );
  }

  onRemove(BuildContext context, int index) {
    if (groupNotifier.chatGroupsOrder.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('삭제 할 수 없는 탭입니다.'),
          action: SnackBarAction(
            label: '확인',
            onPressed: () {},
          ),
        ),
      );
      return;
    }
    groupNotifier.removeTab(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('챗 탭이 삭제되었습니다.'),
        action: SnackBarAction(
          label: '확인',
          onPressed: () {},
        ),
      ),
    );
  }

  Color mainTextColor = const Color(0xFF083e64);

  Future<bool?> dialogBuilder(BuildContext context, int index) {
    if (groupNotifier.chatGroupsOrder.length <= 1) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('삭제할수 없는 탭입니다.'),
            actions: <Widget>[
              FilledButton(
                child: const Text('예'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
    }

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('삭제하시겠습니까?'),
          //content: Text('정말로 해당 챗 그룹을 삭제하시겠습니까? $index'),
          content: const Text('삭제하시겠습니까?'),
          actions: <Widget>[
            FilledButton(
              // style: FilledButton.styleFrom(
              //   textStyle: Theme.of(context).textTheme.labelLarge,
              // ),
              child: const Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              // style: TextButton.styleFrom(
              //   textStyle: Theme.of(context).textTheme.labelLarge,
              // ),
              child: const Text('예'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  buildItem(BuildContext context, int index) {
    var label = groupNotifier.getChatTabLebel(index);
    DateTime? chatdate = groupNotifier.chatTimes[index] ?? DateTime.now();
    var subLabel = DateFormat('yyyy-MM-dd hh:mm').format(chatdate);

    return Card(
        key: Key('${index + 200}'),
        child: ListTile(
            key: Key('$index'),
            trailing: _isEdit
                ? ReorderableDragStartListener(
                    index: index, child: const Icon(Icons.drag_handle))
                : null,
            subtitle: Text(subLabel),
            leading: const Icon(Icons.chat),
            title: Row(children: [
              Text(label),
              const Spacer(),
              _isEdit
                  ? IconButton(
                      onPressed: () {
                        _refreshIndicatorKey.currentState?.show();
                        onRemove(context, index);
                      },
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.redAccent))
                  : Container(),
            ])));
  }
}
