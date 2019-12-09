import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Child(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StartPage(),
        ));
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            ParentWd(),//parent
            ChildWd(),//child
          ],
        ));
  }
}

class ParentWd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      OutlineButton(
        child: Text('Parent 1'),
        shape: StadiumBorder(),
        onPressed: () async {
          await Provider.of<Child>(context, listen: false).getData(1);//load child data
        },
      ),
      OutlineButton(
        child: Text('Parent 2'),
        shape: StadiumBorder(),
        onPressed: () async {
          await Provider.of<Child>(context, listen: false).getData(2);/load child data
        },
      ),
    ]);
  }
}

class ChildWd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Child>(context, listen: false).getData(1),
      builder: (ctx, prevData) {
        if (prevData.connectionState == ConnectionState.waiting) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Center(child: CircularProgressIndicator()),//data is shown but not the CircularProgressIndicator
            ],
          );
        } else {
          if (prevData.error == null) {
            return Consumer<Child>(
              builder: (ctx, data, child) => GridView(
                padding: EdgeInsets.all(2),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: data.children
                    .map(
                      (c) => OutlineButton(
                        child: Text(c.name),
                        shape: StadiumBorder(),
                        onPressed: () {},
                      ),
                    )
                    .toList(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                ),
              ),
            );
          } else {
            return Text('Error');
          }
        }
      },
    );
  }
}

class Child with ChangeNotifier {
  List<ChildItem> _children = [];

  List<ChildItem> get children {
    return [..._children];
  }

  Future<void> getData(int idP) async {
    Future.delayed(const Duration(seconds: 2), () {//simulate server get data with delay
      List<ChildItem> ch = [];
      ch.add(ChildItem(id: 1, name: 'Child 1', idParent: 1));
      ch.add(ChildItem(id: 2, name: 'Child 2', idParent: 1));
      ch.add(ChildItem(id: 3, name: 'Child 3', idParent: 2));

      _children = ch.where((c) => c.idParent == idP).toList();
      notifyListeners();
    });
  }
}

class ChildItem {
  final int id;
  final String name;
  final int idParent;

  ChildItem({
    @required this.id,
    @required this.name,
    @required this.idParent,
  });
}