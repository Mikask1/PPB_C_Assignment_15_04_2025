import 'package:flutter/material.dart';
import 'quote.dart';
import 'quote_card.dart';
import 'quote_dialog.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';

void main() => runApp(MaterialApp(home: QuoteList()));

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  static final _uuid = Uuid();
  late List<Quote> quotes = [];
  final dbHelper = DatabaseHelper.instance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuotesFromDB();
  }

  Future<void> _loadQuotesFromDB() async {
    try {
      final allQuotes = await dbHelper.getAllQuotes();

      if (allQuotes.isEmpty) { // If the database is empty, add sample quotes
        final sampleQuotes = [
          Quote(
            author: 'Oscar Wilde',
            text: 'Be yourself; everyone else is already taken',
            id: _uuid.v4(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        for (var quote in sampleQuotes) {
          await dbHelper.insertQuote(quote);
        }

        quotes = await dbHelper.getAllQuotes();
      } else {
        quotes = allQuotes;
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load quotes');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _addQuote(String author, String text) async {
    try {
      final quote = Quote(
        author: author,
        text: text,
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await dbHelper.insertQuote(quote);
      await _refreshQuotes();
    } catch (e) {
      _showErrorSnackBar('Failed to add quote');
    }
  }

  Future<void> _updateQuote(
    Quote quote,
    String newAuthor,
    String newText,
  ) async {
    try {
      final updatedQuote = Quote(
        author: newAuthor,
        text: newText,
        id: quote.id,
        createdAt: quote.createdAt,
        updatedAt: DateTime.now(),
      );

      await dbHelper.updateQuote(updatedQuote);
      await _refreshQuotes();
    } catch (e) {
      _showErrorSnackBar('Failed to update quote');
    }
  }

  Future<void> _deleteQuote(Quote quote) async {
    try {
      await dbHelper.deleteQuote(quote.id);
      await _refreshQuotes();
    } catch (e) {
      _showErrorSnackBar('Failed to delete quote');
    }
  }

  Future<void> _refreshQuotes() async {
    try {
      final allQuotes = await dbHelper.getAllQuotes();
      if (mounted) {
        setState(() {
          quotes = allQuotes;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to refresh quotes');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Awesome Quotes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return QuoteDialog(
                    onSubmit: (author, text) {
                      _addQuote(author, text);
                    },
                  );
                },
              );
            },
            tooltip: 'Create Quote',
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children:
                      quotes
                          .map(
                            (quote) => QuoteCard(
                              quote: quote,
                              update: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return QuoteDialog(
                                      quote: quote,
                                      onSubmit: (newAuthor, newQuoteText) {
                                        _updateQuote(
                                          quote,
                                          newAuthor,
                                          newQuoteText,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              delete: () {
                                _deleteQuote(quote);
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
    );
  }
}
