import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_menu.dart';

class QuoteCard extends StatelessWidget {
  final Quote quote;
  final Function delete;
  final Function update;
  const QuoteCard({
    super.key,
    required this.quote,
    required this.delete,
    required this.update,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 40.0),
                  Icon(
                    Icons.format_quote,
                    size: 40.0,
                    color: Colors.blue.shade300,
                  ),
                  QuoteMenu(
                    onDelete: delete,
                    onUpdate: update,
                  ),
                ],
              ),
              SizedBox(height: 12.0),
              Text(
                "\"${quote.text}\"",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "- ${quote.author}",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.0),
              SizedBox(height: 16.0),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Created At\t\t: ${quote.createdAt.toString().substring(0, 19)}",
                      style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Updated At\t\t: ${quote.updatedAt.toString().substring(0, 19)}",
                      style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
