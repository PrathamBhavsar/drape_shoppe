import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<String> columnHeaders;
  final List<Map<String, dynamic>> rowData;

  TableWidget({
    Key? key,
    required this.columnHeaders,
    required this.rowData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.grey),
      ),
      columnWidths: Map.fromIterable(
        List.generate(columnHeaders.length, (index) => index),
        key: (index) => index,
        value: (index) => FlexColumnWidth(1),
      ),
      children: [
        // Header row
        TableRow(
          children: columnHeaders.map((header) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                header,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            );
          }).toList(),
        ),

        // Data rows
        ...rowData.map((row) {
          return TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(row.keys.first.toString()), // Access the first key
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:
                    Text(row.values.first.toString()), // Access the first value
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
