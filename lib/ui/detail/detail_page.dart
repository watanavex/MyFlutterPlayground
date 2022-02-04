import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({
    Key? key,
    required this.owner,
    required this.name,
    required this.imageIdentifier,
  }) : super(key: key);

  final String owner;
  final String name;
  final String imageIdentifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const imageWidthFactor = 0.5;
    final size = MediaQuery.of(context).size;
    final placeholder = Icon(
      Icons.person,
      size: size.width * imageWidthFactor,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FractionallySizedBox(
                widthFactor: imageWidthFactor,
                alignment: FractionalOffset.center,
                child: CustomImageWidget(
                  imageUrl: item.owner.avatarUrl,
                  placeholder: () => placeholder,
                  identifier: imageIdentifier,
                ),
              ),
              AutoSizeText(
                item.name,
                style: Theme.of(context).textTheme.headline2,
                maxLines: 1,
              ),
              const SizedBox(height: 15),
              AutoSizeText(
                item.owner.login,
                style: Theme.of(context).textTheme.headline6,
                maxLines: 1,
              ),
              const SizedBox(height: 15),
              Text(
                item.description,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star),
                  Text(
                    item.stargazersCount.toString() + "stars",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.copy),
                  Text(
                    "${item.forksCount} forks",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle_sharp),
                  Text(
                    "Open ${item.openIssuesCount} issues",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
