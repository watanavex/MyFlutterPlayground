import 'package:cached_network_image/cached_network_image.dart';
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
        leading: const Icon(Icons.search),
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
          return _buildListItems(ref, repoItems[index]);
        },
      ),
    );
  }

  Widget _buildListItems(WidgetRef ref, RepoItem item) {
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: item.owner.avatarUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        ),
      ),
      title: Text(item.name),
      subtitle: Text(item.owner.login),
      minLeadingWidth: 56,
    );
  }
}
