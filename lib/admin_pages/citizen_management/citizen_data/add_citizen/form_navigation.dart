import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiPageFormNavigator extends StatefulWidget {
  final List<Widget> pages;
  final int totalPages;
  final VoidCallback? onSubmit;

  const MultiPageFormNavigator({
    super.key,
    required this.pages,
    required this.totalPages,
    this.onSubmit,
  });

  @override
  State<MultiPageFormNavigator> createState() => _MultiPageFormNavigatorState();
}

class _MultiPageFormNavigatorState extends State<MultiPageFormNavigator> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: widget.pages,
          ),
        ),
        const SizedBox(height: 5),

        
        Container(
          color: const Color(0xFF80AF81),
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Column(
            children: [
              const SizedBox(height: 1),
              if (_currentPage == widget.totalPages - 1 && widget.onSubmit != null)
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: ElevatedButton(
          onPressed: widget.onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A7D44),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Submit'),
        ),
      ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentPage > 0
                          ? () => _goToPage(_currentPage - 1)
                          : null,
                    ),
                    Text(
                      'Page ${_currentPage + 1} of ${widget.totalPages}',
                      style: GoogleFonts.inter(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentPage < widget.totalPages - 1
                          ? () => _goToPage(_currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}
