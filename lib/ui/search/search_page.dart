// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 🌎 Project imports:
import 'package:my_flutter_playground/ui/common/async_state_widgets.dart';
import 'package:my_flutter_playground/ui/common/custom_image_widget.dart';
import 'package:my_flutter_playground/ui/detail/detail_page.dart';
import 'package:my_flutter_playground/ui/search/search_page_state.dart';
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
    final repos = ref
        .watch(searchStateNotifierProvider.select((value) => value.asyncState));
    return repos.when(
      uninitialized: () {
        return Container();
      },
      searching: () {
        return buildLoadingWidget(context);
      },
      success: (repos, q, p) {
        return _buildListView(context, ref, repos);
      },
      fetchingNext: (repos, q, p) {
        return _buildListView(context, ref, repos);
      },
      fail: () {
        return buidErrorWidget(context);
      },
      empty: () {
        return buidErrorWidget(context);
      },
    );
  }

  Widget _buildListView(
      BuildContext context, WidgetRef ref, UiRepoListItem repos) {
    final notifier = ref.read(searchStateNotifierProvider.notifier);
    return Scrollbar(
      child: NotificationListener<ScrollNotification>(
        child: ListView.builder(
          itemCount: repos.items.length,
          itemBuilder: (context, index) {
            return _buildListItems(context, ref, repos.items[index]);
          },
        ),
        onNotification: (notification) {
          if (notification.metrics.atEdge &&
              notification.metrics.extentAfter == 0) {
            notifier.fetchNext();
          }
          return false;
        },
      ),
    );
  }

  Widget _buildListItems(BuildContext context, WidgetRef ref, ListItem item) {
    const leadingSize = 56.0;
    const placeholder = Icon(
      Icons.person,
      size: leadingSize,
    );
    return item.when(
      indicator: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      repo: (owner, name, imageUrl) {
        return ListTile(
          leading: CustomImageWidget(
            imageUrl: imageUrl,
            placeholder: () => placeholder,
          ),
          title: Text(
            name,
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            owner,
            style: Theme.of(context).textTheme.caption,
          ),
          minLeadingWidth: leadingSize,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(
                  owner: owner,
                  name: name,
                ),
              ),
            );
          },
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
    debugPrint("_/_/_/Render AppBar");
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
