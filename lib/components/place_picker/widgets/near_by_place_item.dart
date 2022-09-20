import 'package:flutter/material.dart';
import 'package:foap/components/place_picker/entities/entities.dart';

class NearbyPlaceItem extends StatelessWidget {
  final NearbyPlace nearbyPlace;
  final VoidCallback onTap;

  const NearbyPlaceItem(this.nearbyPlace, this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: <Widget>[
              Image.network(nearbyPlace.icon!, width: 16),
              const SizedBox(width: 24),
              Expanded(child: Text("${nearbyPlace.name}", style: Theme.of(context).textTheme.titleSmall))
            ],
          ),
        ),
      ),
    );
  }
}
