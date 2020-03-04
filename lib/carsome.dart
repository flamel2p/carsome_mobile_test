import 'package:carsome_mobile_test/object/album.dart';
import 'package:flutter/material.dart';
import 'package:carsome_mobile_test/blocs/album/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Carsome extends StatefulWidget {
  Carsome({Key key}) : super(key: key);

  @override
  _CarsomeState createState() => _CarsomeState();
}

class _CarsomeState extends State<Carsome> with SingleTickerProviderStateMixin {
  final List<IconData> _tabs = <IconData>[Icons.looks_one, Icons.looks_two];

  List<Tab> _tabBarItems;

  TabController _tabController;

  AlbumListBloc albumListBloc;

  @override
  void initState() {
    super.initState();
    albumListBloc = AlbumListBloc();

    _tabBarItems =
        _tabs.map((t) => Tab(icon: Icon(t, color: Colors.black))).toList();

    _tabController = TabController(length: _tabs.length, vsync: this);

    albumListBloc.add(Fetch(_tabController.index + 1));
  }

  @override
  void dispose() {
    albumListBloc.close();
    super.dispose();
  }

  void fetchTab(int index) {
    albumListBloc.add(Fetch(index + 1));
    return;
  }

  void launchGitHubRepo() async {
    final String url = 'https://github.com/flamel2p/carsome_mobile_test';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => launchGitHubRepo(),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorPadding: const EdgeInsets.all(4.0),
            indicator: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.blue,
                width: 1,
              ),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: _tabBarItems,
            onTap: fetchTab,
          ),
          Expanded(
            child: BlocProvider<AlbumListBloc>(
              create: (context) => albumListBloc,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  AlbumListView(),
                  AlbumListView(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlbumListView extends StatelessWidget {
  const AlbumListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumListBloc, AlbumListState>(
      builder: (BuildContext context, AlbumListState state) {
        if (state is AlbumListError) {
          return RefreshIndicator(
            onRefresh: () {
              context.bloc<AlbumListBloc>().add(Refresh());
              return Future.value();
            },
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(state.error),
                ),
              ],
            ),
          );
        }

        if (state is AlbumListLoaded) {
          return RefreshIndicator(
            onRefresh: () {
              context.bloc<AlbumListBloc>().add(Refresh());
              return Future.value();
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 64),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.85,
                ),
                itemCount: state.albumList.length,
                itemBuilder: (context, index) {
                  final Album _album = state.albumList.albumns[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.network(
                        _album.thumbnailUrl,
                        width: 150,
                        fit: BoxFit.fitWidth,
                      ),
                      Text(
                        _album.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
