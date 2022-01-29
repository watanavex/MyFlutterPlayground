import 'package:flutter/material.dart';
import 'package:my_flutter_playground/api/api_client.dart';
import 'package:my_flutter_playground/api/search_api.dart';
import 'package:my_flutter_playground/model/repo_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _repoItems = <RepoItem>[];
  final _searchApi = SearchApi(provideDio());

  void _search(String query) async {
    final searchResult = await _searchApi.search(query);
    setState(() {
      _repoItems = searchResult.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        title: TextField(
          decoration: const InputDecoration(
            hintText: '検索ワードを入力してください',
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (string) {
            _search(string);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _repoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipOval(
              child: Image.network(_repoItems[index].owner.avatarUrl),
            ),
            title: Text(_repoItems[index].name),
            subtitle: Text(_repoItems[index].owner.login),
          );
        },
      ),
    );
  }
}
