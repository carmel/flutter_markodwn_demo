import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double position = 61.0;
  double fontSize = 18;
  final _wrapAlignment = WrapAlignment.start;
  Future<String> get data => rootBundle.loadString('assets/markdown_test_page.md');
  late AutoScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        initialScrollOffset: controller.position.maxScrollExtent * position / 100,
        viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   setState(() {
    //     controller.jumpTo(controller.position.maxScrollExtent * position / 100);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        controller: controller,
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            elevation: 4,
            automaticallyImplyLeading: false,
            title: Text('flutter markdown demo'),
          ),
          FutureBuilder<String>(
              future: data,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return PositionableMarkdown(
                      controller: controller,
                      data: snapshot.data ?? '',
                      selectable: true,
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        blockSpacing: 14,
                        p: TextStyle(fontSize: fontSize),
                        listBullet: TextStyle(fontSize: fontSize),
                        listIndent: 34,
                        textAlign: _wrapAlignment,
                        h1Align: _wrapAlignment,
                        h2Align: _wrapAlignment,
                        h3Align: _wrapAlignment,
                        h4Align: _wrapAlignment,
                        h5Align: _wrapAlignment,
                        h6Align: _wrapAlignment,
                        unorderedListAlign: _wrapAlignment,
                        orderedListAlign: _wrapAlignment,
                        blockquoteAlign: _wrapAlignment,
                        codeblockAlign: _wrapAlignment,
                      ));
                } else {
                  return SliverToBoxAdapter(child: const CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}
