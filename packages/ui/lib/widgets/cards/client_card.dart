import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  // final UserModel user;
  final bool transparent;
  final List<Widget> additionalInfo;
  const ClientCard({
    super.key,
    // required this.user,
    this.transparent = false,
    this.additionalInfo = const [],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Get.to(const ArtistProfileView()),
      child: SizedBox(
        height: 110,
        child: Card(
          elevation: 0,
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
                    // ...(user.photoURL != null
                    //     ? [
                    //         ClipRRect(
                    //             borderRadius: BorderRadius.circular(10),
                    //             child: Hero(
                    //               tag: "client-profile-${user.id}",
                    //               child: Image(
                    //                 image: NetworkImage(user.photoURL!),
                    //                 width: 85,
                    //                 height: 85,
                    //                 fit: BoxFit.fitWidth,
                    //               ),
                    //             )),
                    //         const SizedBox(
                    //           width: 10,
                    //         ),
                    //       ]
                    //     : []),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // user.name!,
                          "Client Name",
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ...additionalInfo,
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
