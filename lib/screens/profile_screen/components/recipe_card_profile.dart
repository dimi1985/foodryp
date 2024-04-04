import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';

class RecipeCardProfile extends StatefulWidget {
  const RecipeCardProfile({super.key});

  @override
  State<RecipeCardProfile> createState() => _RecipeCardProfileState();
}

class _RecipeCardProfileState extends State<RecipeCardProfile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.separated(
        itemCount: DemoData.regularRecipes.length,
        itemBuilder: (context, index) {
          final regularRecipe = DemoData.regularRecipes[index];
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Material(
              borderRadius: BorderRadius.circular(7.0),
              elevation: 2.0,
              child: Container(
                height: 125.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            Text(
                              regularRecipe['title'],
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            const Row(
                              children: [
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 3.0),
                                Text('25')
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 7.0),
                        const Text(
                          'Category',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10.0),
                    const Spacer(),
                    Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                regularRecipe['image'],
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(7.0)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 20,
          );
        },
      ),
    );
  }
}
