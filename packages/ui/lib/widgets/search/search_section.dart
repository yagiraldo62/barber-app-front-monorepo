import 'package:ui/widgets/map/map_box_view.dart';
import 'package:ui/widgets/search/search_input.dart';
import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          const Column(children: [SizedBox(height: 20), MapBoxView()]),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Explorar", style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: SearchInput(
                    hintText: "Search Products...",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
