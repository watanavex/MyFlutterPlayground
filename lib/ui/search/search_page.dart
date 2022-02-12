import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final repos =
        ref.watch(searchStateNotifierProvider.select((value) => value.repos));
    return repos.on(
      context: context,
      success: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildListItems(context, ref, data[index]);
          },
        );
      },
    );
  }

  Widget _buildListItems(BuildContext context, WidgetRef ref, Repo repo) {
    const leadingSize = 56.0;
    const placeholder = Icon(
      Icons.person,
      size: leadingSize,
    );
    return ListTile(
      leading: CustomImageWidget(
        imageUrl: repo.imageUrl,
        placeholder: () => placeholder,
      ),
      title: Text(
        repo.name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        repo.owner,
        style: Theme.of(context).textTheme.caption,
      ),
      minLeadingWidth: leadingSize,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(
              owner: repo.owner,
              name: repo.name,
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
