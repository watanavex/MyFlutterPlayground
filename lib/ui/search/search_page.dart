import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/model/repo_item.dart';
import 'package:my_flutter_playground/ui/common/async_state_widgets.dart';
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
      body: repoItems.on(
        success: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildListItems(ref, data[index]);
          },
        ),
      ),
    );
  }

  Widget _buildListItems(WidgetRef ref, RepoItem item) {
    const leadingSize = 56.0;
    const placeholder = Icon(
      Icons.person,
      size: leadingSize,
    );
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: item.owner.avatarUrl,
          placeholder: (context, url) => placeholder,
          errorWidget: (context, url, error) => placeholder,
        ),
      ),
      title: Text(item.name),
      subtitle: Text(item.owner.login),
      minLeadingWidth: leadingSize,
    );
  }
}