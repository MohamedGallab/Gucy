import 'package:flutter/material.dart';

class Flare extends StatelessWidget {
  final String tag;

  const Flare({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Text(
        tag,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}