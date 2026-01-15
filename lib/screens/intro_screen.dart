import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'tasks_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              Container(
                color: Colors.yellow,
                child: Image.asset('assets/images/sleep.png'),
              ),
              Container(
                color: Colors.yellow,
                child: Image.asset('assets/images/exercise.png'),
              ),
              Container(
                color: Colors.yellow,
                child: Image.asset('assets/images/work.png'),
              ),
            ],
          ),
          Align(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TasksPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'skip',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const SwapEffect(
                    dotColor: Colors.blue,
                    activeDotColor: Colors.white,
                    type: SwapType.yRotation,
                  ),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TasksPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'done',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.grey,
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
