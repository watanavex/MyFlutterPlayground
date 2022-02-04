import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_flutter_playground/model/repo_item.dart';
import 'package:my_flutter_playground/ui/common/async_state_widgets.dart';
import 'package:my_flutter_playground/ui/common/custom_image_widget.dart';
import 'package:my_flutter_playground/ui/detail/detail_page.dart';
import 'package:my_flutter_playground/ui/search/search_page_state_notifier.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _MyAppBar(),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final repoItems = ref
        .watch(searchStateNotifierProvider.select((value) => value.repoItems));
    return repoItems.on(
      context: context,
      success: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildListItems(context, ref, index, data[index]);
          },
        );
      },
    );
  }

  Widget _buildListItems(
      BuildContext context, WidgetRef ref, int index, RepoItem item) {
    const leadingSize = 56.0;
    const placeholder = Icon(
      Icons.person,
      size: leadingSize,
    );
    final imageIdentifier = item.owner.avatarUrl + index.toString();
    return ListTile(
      leading: CustomImageWidget(
        imageUrl: item.owner.avatarUrl,
        placeholder: () => placeholder,
        identifier: imageIdentifier,
      ),
      title: Text(
        item.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        item.owner.login,
        style: Theme.of(context).textTheme.caption,
      ),
      minLeadingWidth: leadingSize,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(
              item: item,
              imageIdentifier: imageIdentifier,
            ),
          ),
        );
      },
    );
  }
}

class _MyAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final _searchIcon = const Icon(Icons.search);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Render AppBar");
    final isSearchMode = ref.watch(
        searchStateNotifierProvider.select((value) => value.isSearchMode));
    return isSearchMode ? _buildSearchBar(ref) : _buildNormalBar(ref);
  }

  PreferredSizeWidget _buildNormalBar(WidgetRef ref) {
    final stateNotifier = ref.watch(searchStateNotifierProvider.notifier);
    return AppBar(
      title: const Text("Github Search App"),
      actions: [
        IconButton(
          onPressed: () => stateNotifier.toggleMode(),
          icon: _searchIcon,
        )
      ],
    );
  }

  PreferredSizeWidget _buildSearchBar(WidgetRef ref) {
    final stateNotifier = ref.watch(searchStateNotifierProvider.notifier);
    return AppBar(
      leading: _searchIcon,
      title: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: '検索ワードを入力してください',
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (string) {
          stateNotifier.searchRepos(string);
        },
      ),
      actions: [
        IconButton(
          onPressed: () => stateNotifier.toggleMode(),
          icon: const Icon(Icons.close),
        )
      ],
    );
  }
}
