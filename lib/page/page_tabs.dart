import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final notifierLocation = context.read<LocationChangeNotifier>();
    // final notifierDay = context.read<DayChangeNotifier>();
    // final map = notifierLocation.addressesMap;

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
          onRefresh: () async {
            if (isRemoving == true) {
              await onRemove(_context, _index);
              isRemoving = false;
            }

            if (isSwapping == true) {
              await onSwap(_oldIndex, _newIndex);
              isSwapping = false;
            }

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
                  // _notifierLocation = notifierLocation;
                  // _notifierDay = notifierDay;
                  isSwapping = true;
                  _refreshIndicatorKey.currentState?.show();
                },
                //footer: buildButton(context, map.length),
                footer: buildButton(context, 1),
              ),
            )),
          ]),
        ));
  }

  bool isSwapping = false;
  // late LocationChangeNotifier _notifierLocation;
  // late DayChangeNotifier _notifierDay;
  late int _oldIndex;
  late int _newIndex;

  onSwap(int oldIndex, int newIndex) async {
    // await _notifierLocation.OnReorder(oldIndex, newIndex);
    // await _notifierDay.SwapChange(oldIndex, newIndex);
    setState(() {
      //_notifierLocation.notifyListeners();
    });
  }

  bool isRemoving = false;

  onRemove(BuildContext context, int index) async {
    //isRemoving = true;
    //final notifierLocation = context.read<LocationChangeNotifier>();
    //final deletedItem = await notifierLocation.OnRemove(index);

    //final notifierDay = context.read<DayChangeNotifier>();
    //notifierDay.RemoveLocationData(deletedItem);

    setState(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('1111 이(가) 삭제되었습니다.')),
      );
    });
    //isRemoving = false;
  }

  Color mainTextColor = const Color(0xFF083e64);
  late BuildContext _context;
  late int _index;

  buildListAll(BuildContext context) {
    //final notifierLocation = context.read<LocationChangeNotifier>();
    //final keys = notifierLocation.locationNameList;

    List<Widget> widgets = [];
    // TEST
    List<String> keys = ['0', '1', '2'];

    if (_isEdit) {
      for (int i = 0; i < keys.length; i++) {
        widgets.add(Container(
            key: Key('$i'),
            child: Dismissible(
                background: Container(
                  color: Colors.red,
                ),
                key: ValueKey<String>(keys[i]),
                onDismissed: (DismissDirection direction) {
                  //notifierLocation.OnRemove(i).then((value) => setState(() {}));
                  _context = context;
                  _index = i;
                  isRemoving = true;
                  _refreshIndicatorKey.currentState?.show();
                  //OnRemove(context, i);
                },
                child: buildItem(context, i))));
      }
    } else {
      for (int i = 0; i < keys.length; i++) {
        widgets.add(buildItem(context, i));
      }
    }

    return widgets;
  }

  buildItem(BuildContext context, int index) {
    // final notifierLocation = context.read<LocationChangeNotifier>();
    // final map = notifierLocation.addressesMap;
    // final keys = notifierLocation.locationNameList;
    // final NameAddress? address = map[keys[index]];

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
              const Text('address!.addressName'),
              const Spacer(),
              _isEdit
                  ? IconButton(
                      onPressed: () {
                        // notifierLocation.OnRemove(index)
                        //     .then((value) => setState(() {}));

                        _context = context;
                        _index = index;
                        isRemoving = true;
                        _refreshIndicatorKey.currentState?.show();
                        //OnRemove(context, index);
                      },
                      icon: const Icon(Icons.remove_circle,
                          color: Colors.redAccent))
                  : Container(),
              //SizedBox(width: 30),
            ])));
  }

  buildButton(BuildContext context, int index) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextButton(
          onPressed: () {},
          // => Navigator.popAndPushNamed(
          //     //Navigator.pushNamed(
          //     context,
          //     GlobalDefine.RouteNameAddAddress),
          child: const Text(
            '추가하기',
            //   style: TextStyle(
            //     //color: mainTextColor,
            //     fontFamily: 'SpoqaHanSansNeo',
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 1,
            //     //package: App.pkg
            //   ),
          ),
        ),
      ],
    );
  }
}
