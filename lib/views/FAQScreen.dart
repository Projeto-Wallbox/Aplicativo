import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqItems = [
    {'question': 'Pergunta?', 'answer': 'Resposta'},
    {'question': 'Pergunta?', 'answer': 'Resposta'},
    {'question': 'Pergunta?', 'answer': 'Resposta'},
    {'question': 'Pergunta?', 'answer': 'Resposta'},
    {'question': 'Pergunta?', 'answer': 'Resposta'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqItems[index]['question']!),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  faqItems[index]['answer']!,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
