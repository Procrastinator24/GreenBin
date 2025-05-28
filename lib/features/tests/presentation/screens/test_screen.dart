import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/features/tests/presentation/screens/test_details_screen.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Знай и дейстуй')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tests')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          if (data == null || data.docs.isEmpty) {
            return Center(child: Text('Нет тестов'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.docs.length,
            itemBuilder: (context, index) {
              final doc = data.docs[index];
              final test = {
                'title': doc['title'],
                'description': doc['description'],
                'imageUrl': doc['imageUrl'],
                'topicsCount': doc['topicsCount'],
              };
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestDetails(testId: doc.id),
                      ),
                    );
                  },
                  child: Container(
                    width: 324,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                            width :100,
                            height :144,
                            decoration : BoxDecoration(
                              borderRadius : BorderRadius.all(Radius.circular(20)),
                              image : DecorationImage(image : NetworkImage(test['imageUrl']), fit : BoxFit.contain)
                            ),
                          ),
                          // Название и описание
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    test['title'],
                                    style:
                                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    test['description'],
                                    style:
                                        TextStyle(fontSize: 14, color: Colors.grey[600]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Разделительная линия
                      Divider(color : Colors.grey[300], height :1),
                      // Вторая строка с "Пройдено тем" и количеством тем
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child:
                            Row(mainAxisAlignment : MainAxisAlignment.spaceBetween, children:[
                          Text('Пройдено тем', style : TextStyle(fontSize :12 , color : Colors.grey[500])),
                          Text('0/${test['topicsCount']}', style : TextStyle(fontSize :12 , color : Colors.grey[500]))
                        ]),
                      )
                    ],
                  ),
                ),
              )
              );
            },
          );
        },
      ),
    );
  }
}