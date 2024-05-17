import 'package:flutter/material.dart';
import 'package:foodryp/models/wikifood.dart';
import 'package:foodryp/screens/admin/components/add_wiki_food.dart';
import 'package:foodryp/utils/wiki_food_service.dart';

class AdminFoodWikiPage extends StatefulWidget {
  const AdminFoodWikiPage({super.key});

  @override
  State<AdminFoodWikiPage> createState() => _AdminFoodWikiPageState();
}

class _AdminFoodWikiPageState extends State<AdminFoodWikiPage> {
  List<Wikifood> wikifoods = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchWikifoods();
  }

  Future<void> _fetchWikifoods() async {
    try {
      setState(() {
        isLoading = true;
      });
      final List<Wikifood> newWikifoods = await WikiFoodService().getWikiFoodsByPage(currentPage, pageSize);
      setState(() {
        wikifoods.addAll(newWikifoods);
        currentPage++; // Increment page for next fetch
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error fetching wikifoods: $e');
    }
  }

  Future<void> _refreshList() async {
    setState(() {
      wikifoods.clear();
      currentPage = 1;
    });
    await _fetchWikifoods();
  }

  Future<void> _navigateToAddUpdatePage(Wikifood? wikifood) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUpdateDeleteWikiFoodPage(wikifood: wikifood)),
    );

    if (result == true) {
      _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wiki Food Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: wikifoods.length,
              itemBuilder: (context, index) {
                final wikifood = wikifoods[index];
                return ListTile(
                  title: Text(wikifood.title),
                  subtitle: Text(wikifood.text),
                  onTap: () => _navigateToAddUpdatePage(wikifood),
                );
              },
            ),
          ),
          if (isLoading)
            const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: isLoading ? null : _fetchWikifoods,
              child: const Text('Load More'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => _navigateToAddUpdatePage(null),
              child: const Text('Add Wiki Food'),
            ),
          ),
        ],
      ),
    );
  }
}
