import 'package:ui/widgets/horizontal_introduction/animated_page_transition.dart';
import 'package:flutter/material.dart';

class HorizontalIntroduction extends StatefulWidget {
  final List<Widget> pages;
  final VoidCallback? onFinish;

  const HorizontalIntroduction({super.key, required this.pages, this.onFinish});

  @override
  _HorizontalIntroductionState createState() => _HorizontalIntroductionState();
}

class _HorizontalIntroductionState extends State<HorizontalIntroduction> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (widget.onFinish != null) {
      widget.onFinish!();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Páginas animadas
          PageView.builder(
            scrollDirection: Axis.vertical,

            controller: _pageController,
            itemCount: widget.pages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return AnimatedPageTransition(
                pageController: _pageController,
                index: index,
                child: widget.pages[index],
              );
            },
          ),

          // Controles de navegación en la parte inferior
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: _goToPreviousPage,
                    child: const Text('Anterior'),
                  ),

                // Indicadores de página
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                      ),
                    ),
                  ),
                ),

                // Botón siguiente o finalizar
                TextButton(
                  onPressed: _goToNextPage,
                  child: Text(
                    _currentPage < widget.pages.length - 1
                        ? 'Siguiente'
                        : 'Finalizar',
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
