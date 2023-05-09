import 'package:chat_playground/models/chatgroup_notifier.dart';
import 'package:flutter/material.dart';
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
    groupNotifier = context.watch<ChatGroupNotifier>();

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
            // if (isRemoving == true) {
            //   onRemove(_context, _index);
            //   isRemoving = false;
            // }

            // if (isSwapping == true) {
            //   onSwap(_oldIndex, _newIndex);
            //   isSwapping = false;
            // }
            return Future<void>.sync(() => null);
            //return Future<void>.delayed(const Duration(seconds: 3));
          },

          // Pull from top to show refresh indicator.
          child: Flex(direction: Axis.vertical, children: <Widget>[
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ReorderableListView(
                header: _isEdit ? const Text('위치를 이동하거나 좌우로 지우세요') : null,
                buildDefaultDragHandles: _isEdit,
                children: buildListAll(context),
                onReorder: (int oldIndex, int newIndex) {
                  _oldIndex = oldIndex;
                  _newIndex = newIndex;
                  isSwapping = true;
                  _refreshIndicatorKey.currentState?.show();
                },
                footer: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        onAddTab(context);
                      },
                      child: const Text(
                        '추가하기',
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ]),
        ));
  }

  bool isSwapping = false;
  late int _oldIndex;
  late int _newIndex;

  onSwap(int oldIndex, int newIndex) {
    groupNotifier.swapTab(oldIndex, newIndex);
  }

  bool isRemoving = false;

  onAddTab(BuildContext context) {
    groupNotifier.addTab();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('챗 탭이 추가되었습니다.')),
    );
  }

  onRemove(BuildContext context, int index) {
    groupNotifier.removeTab(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('챗 탭이 삭제되었습니다.')),
    );
  }

  Color mainTextColor = const Color(0xFF083e64);
  late BuildContext _context;
  late int _index;

  buildListAll(BuildContext context) {
    List<Widget> widgets = [];
    // TEST
    //List<String> keys = ['0', '1', '2'];

    if (_isEdit) {
      for (int i = 0; i < groupNotifier.chatGroups.length; i++) {
        widgets.add(Container(
            key: Key('$i'),
            child: Dismissible(
                background: Container(
                  color: Colors.red,
                ),
                key: ValueKey<String>(groupNotifier.chatGroups[i].toString()),
                onDismissed: (DismissDirection direction) {
                  //notifierLocation.OnRemove(i).then((value) => setState(() {}));
                  _context = context;
                  _index = i;
                  isRemoving = true;
                  _refreshIndicatorKey.currentState?.show();
                  onRemove(context, i);
                },
                child: buildItem(context, i))));
      }
    } else {
      for (int i = 0; i < groupNotifier.chatGroups.length; i++) {
        widgets.add(buildItem(context, i));
      }
    }

    return widgets;
  }

  buildItem(BuildContext context, int index) {
    // double value = context.select<ChatGroupNotifier, double>
    // ((provider) => provider.value!);

    var label = groupNotifier.getChatTabLebel(index);

    return Card(
        key: Key('${index + 200}'),
        child: ListTile(
            key: Key('$index'),
            trailing: _isEdit
                ? ReorderableDragStartListener(
                    index: index, child: const Icon(Icons.drag_handle))
                : null,
            title: Row(children: [
              const Icon(Icons.map_rounded),
              const SizedBox(width: 20),
              Text(label),
              const Spacer(),
              _isEdit
                  ? IconButton(
                      onPressed: () {
                        _context = context;
                        _index = index;
                        isRemoving = true;
                        _refreshIndicatorKey.currentState?.show();
                        onRemove(context, index);
                      },
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.redAccent))
                  : Container(),
            ])));
  }
}
