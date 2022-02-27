// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:my_flutter_playground/ui/common/async_state_widgets.dart';
import 'package:my_flutter_playground/ui/common/custom_image_widget.dart';
import 'detail_page_state_notifier.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({
    Key? key,
    required this.owner,
    required this.name,
  }) : super(key: key);

  final String owner;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final detail = ref
        .watch(detailPageStateNotifierProvider.select((value) => value.detail));
    final notifier = ref.watch(detailPageStateNotifierProvider.notifier);
    useEffect(() {
      notifier.fetch(owner: owner, repo: name);
    }, []);

    return detail.on(
      context: context,
      success: (data) {
        return Center(
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOwnerImage(context, data.imageUrl),
                const SizedBox(height: 15),
                _buildAutoTextHeadline2(context, data.name),
                const SizedBox(height: 15),
                _buildAutoTextHeadline6(context, data.owner),
                const SizedBox(height: 15),
                if (data.description != null)
                  _buildTextCaption(context, data.description!),
                const SizedBox(height: 15),
                _buildAutoTextHeadline6(context, data.language ?? ""),
                const SizedBox(height: 60),
                _buildIconWithText(context, const Icon(Icons.copy),
                    "${data.forksCount} forks"),
                const SizedBox(height: 15),
                _buildIconWithText(
                    context, const Icon(Icons.star), "${data.starCount} stars"),
                const SizedBox(height: 15),
                _buildIconWithText(context, const Icon(Icons.remove_red_eye),
                    "${data.watchersCount} watchers"),
                const SizedBox(height: 15),
                _buildIconWithText(
                    context,
                    const Icon(Icons.remove_circle_sharp),
                    "open ${data.issueCount} issues"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOwnerImage(BuildContext context, String imageUrl) {
    const imageWidthFactor = 0.5;
    final size = MediaQuery.of(context).size;
    final placeholder = Icon(
      Icons.person,
      size: size.width * imageWidthFactor,
    );
    return FractionallySizedBox(
      widthFactor: imageWidthFactor,
      alignment: FractionalOffset.center,
      child: CustomImageWidget(
        imageUrl: imageUrl,
        placeholder: () => placeholder,
      ),
    );
  }

  Widget _buildAutoTextHeadline2(BuildContext context, String text) {
    return AutoSizeText(
      text,
      style: Theme.of(context).textTheme.headline2,
      maxLines: 1,
    );
  }

  Widget _buildAutoTextHeadline6(BuildContext context, String text) {
    return AutoSizeText(
      text,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
    );
  }

  Widget _buildTextCaption(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.caption,
    );
  }

  Widget _buildIconWithText(BuildContext context, Icon icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 5),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}
