import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/provider/search_location_provider.dart';

import 'search_results_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.21, -0.98),
            end: Alignment(0.21, 0.98),
            colors: [
              Color(0xFF391A49),
              Color(0xFF2F1D5B),
              Color(0xFF262171),
              Color(0xFF301D5B),
              Color(0xFF391A49)
            ],
          ),
        ),
        child: const SearchWidget(),
      ),
    );
  }
}

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  bool isTapped = false;
  late FocusNode _focusNode;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(searchStringProvider);
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 38, left: 24, right: 24),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 4),
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.60,
                  child: Container(
                    width: double.infinity,
                    height: 59,
                    decoration: ShapeDecoration(
                      color: const Color(0xB2AAA5A5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            ref
                                .read(searchStringProvider.notifier)
                                .update((state) => value);
                          },
                          focusNode: _focusNode,
                          onTap: () {
                            setState(() {
                              isTapped = !isTapped;
                            });
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          cursorColor: Colors.white,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.80),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            suffixIcon: _focusNode.hasFocus
                                ? GestureDetector(
                                    onTap: () {
                                      // Dismiss the keyboard
                                      FocusScope.of(context).unfocus();
                                      !_focusNode.hasFocus;
                                      //remove the search string
                                      ref.invalidate(searchStringProvider);
                                      _controller.text = '';
                                    },
                                    child: const Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : Transform.scale(
                                    scale: 0.5,
                                    child: SvgPicture.asset(
                                      'assets/images/icon_search.svg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            border: InputBorder.none,
                            hintText: 'Enter Location',
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.80),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SearchResultsWidget(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
