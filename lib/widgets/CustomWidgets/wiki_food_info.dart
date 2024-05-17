import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/wikifood.dart';

class WikiFoodInfo extends StatelessWidget {
  final Wikifood wikiInfo;

  const WikiFoodInfo({required this.wikiInfo, super.key});

  @override
  Widget build(BuildContext context) {
  
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wikiInfo.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            wikiInfo.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Source: ${wikiInfo.source}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
