import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodryp/utils/app_localizations.dart';

class MeasurementConversionTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            TableRow(
              children: [
                _buildTableCell(
                    AppLocalizations.of(context).translate('Imperial')),
                _buildTableCell(
                    AppLocalizations.of(context).translate('Metric')),
              ],
            ),
            TableRow(
              children: [
                
                _buildTableCell(AppLocalizations.of(context).translate('1 ounce')),
                _buildTableCell('28.35 g'),
              ],
            ),
            TableRow(
              
              children: [
                _buildTableCell(AppLocalizations.of(context).translate('1 pound')),
                _buildTableCell('0.45 kg'),
              ],
            ),
            TableRow(
             
              children: [
                _buildTableCell( AppLocalizations.of(context).translate('1 quart')),
                _buildTableCell('0.95 L'),
              ],
            ),
            TableRow(
              
              children: [
                _buildTableCell(AppLocalizations.of(context).translate('1 pint')),
                _buildTableCell('0.47 L'),
              ],
            ),
            TableRow(
              
              children: [
                _buildTableCell(AppLocalizations.of(context).translate('1 cup')),
                _buildTableCell('240 mL'),
              ],
            ),
            TableRow(
              
              children: [
                _buildTableCell(AppLocalizations.of(context).translate('1 tablespoon')),
                _buildTableCell('15 mL'),
              ],
            ),
            TableRow(
              
              children: [
                _buildTableCell(AppLocalizations.of(context).translate('1 teaspoon')),
                _buildTableCell('5 mL'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
