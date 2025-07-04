import 'package:flutter/material.dart';
import 'package:ui/theme/colors.dart';

class ArtistCard extends StatelessWidget {
  final bool image;
  final bool transparent;
  const ArtistCard({super.key, this.image = true, this.transparent = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Get.to(const ArtistProfileView()),
      child: SizedBox(
        height: 120,
        child: Card(
          color:
              transparent
                  ? Theme.of(context).cardTheme.color?.withOpacity(0.85)
                  : Theme.of(context).cardTheme.color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...(image
                        ? [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const Hero(
                              tag: "baber-profile-1",
                              child: Image(
                                image: AssetImage("assets/images/b1.jpg"),
                                width: 85,
                                height: 85,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ]
                        : []),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "PRO - ACTIVO",
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "2:00 PM - 9:30 PM",
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: DarkThemePalette.gray),
                            ),
                          ],
                        ),
                        Text(
                          "Iván Garcia",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.normal),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "4.7 (135)",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 25),
                            const Icon(Icons.location_on),
                            const SizedBox(width: 8),
                            Text(
                              "120 mts",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
