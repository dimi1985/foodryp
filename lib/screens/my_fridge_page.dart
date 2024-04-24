import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_app_bar.dart';
import 'package:foodryp/widgets/CustomWidgets/menuWebItems.dart';

class MyFridgePage extends StatefulWidget {
  final User user;
  const MyFridgePage({Key? key, required this.user}) : super(key: key);

  @override
  State<MyFridgePage> createState() => _MyFridgePageState();
}

class _MyFridgePageState extends State<MyFridgePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String currentPage;
  bool doorsOpened = false;

  @override
  void initState() {
    super.initState();
    currentPage = 'My Fridge';
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFridge() {
    setState(() {
      doorsOpened = !doorsOpened;
    });
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: kIsWeb
          ? CustomAppBar(
              isDesktop: true,
              isAuthenticated: true,
              profileImage: widget.user.profileImage,
              username: widget.user.username,
              onTapProfile: () {
                // Handle profile onTap action
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      user: widget.user,
                    ),
                  ),
                );
              },
              user: widget.user,
              menuItems: isDesktop
                  ? MenuWebItems(
                      user: widget.user,
                      currentPage: currentPage,
                    )
                  : Container(),
            )
          : AppBar(),
      endDrawer: !isDesktop
          ? MenuWebItems(
              user: widget.user,
              currentPage: currentPage,
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 500,
                  child: Row(
                    children: [
                      Expanded(child: _buildColumn('Vegetables')),
                      Expanded(child: _buildColumn('Milk and Dairy')),
                      Expanded(child: _buildColumn('Meat and Fish')),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        -MediaQuery.of(context).size.width * _animation.value,
                        0,
                      ),
                      child: _buildFridgeVisualization(context),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        MediaQuery.of(context).size.width * _animation.value,
                        0,
                      ),
                      child: _buildFridgeVisualization(context),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleFridge,
              child: Text(doorsOpened ? 'Close Fridge' : 'Open Fridge'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFridgeVisualization(BuildContext context) {
    return Container(
      height: 800,
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 84, 7, 228),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Fridge',
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _toggleFridge,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              doorsOpened ? 'Close Doors' : 'Open Doors',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        // Placeholder for items corresponding to the category
        // Replace this with your actual implementation
        Container(
          height: 200,
          width: 100,
          color: Colors.white,
          child: const Center(
            child: Text('Items'),
          ),
        ),
      ],
    );
  }
}
