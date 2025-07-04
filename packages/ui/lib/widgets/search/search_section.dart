import 'package:ui/widgets/map/map_box_view.dart';
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
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardTheme.surfaceTintColor,
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10,
                      ),
                      /* -- Text and Icon -- */
                      hintText: "Search Products...",
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 127, 127, 127),
                      ),
                      suffixIcon: const Icon(Icons.search), // Icon
                      /* -- Border Styling -- */
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),

                      // OutlineInputBorder
                    ), // InputDecoration
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
