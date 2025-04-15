import 'package:flutter/material.dart';
import 'quote.dart';

class QuoteDialog extends StatefulWidget {
  final Quote? quote;
  final Function(String author, String text) onSubmit;

  const QuoteDialog({super.key, this.quote, required this.onSubmit});

  @override
  State<QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  late TextEditingController _authorController;
  late TextEditingController _quoteController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authorController = TextEditingController(text: widget.quote?.author ?? '');
    _quoteController = TextEditingController(text: widget.quote?.text ?? '');
  }

  @override
  void dispose() {
    _authorController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      backgroundColor: Colors.grey[200],
      title: Row(
        children: [
          Icon(
            widget.quote == null ? Icons.add_circle_outline : Icons.edit_note,
            color: Colors.grey[800],
          ),
          const SizedBox(width: 8),
          Text(
            widget.quote == null ? 'Add New Quote' : 'Update Quote',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(
                hintText: 'Author',
                labelText: 'Author Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an author name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quoteController,
              decoration: InputDecoration(
                hintText: 'Enter your quote here...',
                labelText: 'Quote Text',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.format_quote),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quote';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.close, color: Colors.grey[800]),
                  label: Text('Cancel', style: TextStyle(color: Colors.grey[800])),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: Icon(widget.quote == null ? Icons.add : Icons.save, color: Colors.white),
                  label: Text(widget.quote == null ? 'Add Quote' : 'Update', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade300,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit(
                        _authorController.text.trim(),
                        _quoteController.text.trim(),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}