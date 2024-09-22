import 'package:flutter/material.dart';

class PrecipitationProbability extends StatelessWidget {
  const PrecipitationProbability(
    this.probability, {
    super.key,
  });

  final int probability;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.water_drop,
          size: 12,
          color:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(.7),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          '$probability%',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(.7)),
        )
      ],
    );
  }
}
