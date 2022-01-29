import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/ui/search/search_page_state_notifier.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateNotifier = ref.watch(searchStateNotifierProvider.notifier);
    final repoItems = ref
        .watch(searchStateNotifierProvider.select((value) => value.repoItems));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        title: TextField(
          decoration: const InputDecoration(
            hintText: '検索ワードを入力してください',
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (string) {
            stateNotifier.searchRepos(string);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: repoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipOval(
              child: Image.network(repoItems[index].owner.avatarUrl),
            ),
            title: Text(repoItems[index].name),
            subtitle: Text(repoItems[index].owner.login),
          );
        },
      ),
    );
  }
}
