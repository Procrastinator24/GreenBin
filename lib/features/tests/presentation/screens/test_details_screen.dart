import 'package:flutter/material.dart';

class TestDetails extends StatelessWidget {
  // Можно передавать сюда id теста или другие параметры при необходимости
  // final String testId;
  final String testId;
  const TestDetails({Key? key, required this.testId}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали теста'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок теста
            Text(
              'Название теста',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Описание теста
            Text(
              'Описание теста будет отображаться здесь. Это заглушка.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            // Раздел вопросов или деталей
            Text(
              'Вопросы и детали',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // Здесь можно начать верстать список вопросов или другую информацию
            // Например, список вопросов:
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5, // Заглушка — количество вопросов
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Нумерация вопроса
                        Text(
                          'Вопрос ${index + 1}',
                          style:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        // Текст вопроса-заглушка
                        Text(
                          'Текст вопроса будет здесь.',
                          style:
                              TextStyle(fontSize :14 , color : Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Можно добавить дополнительные разделы или кнопки
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Обработка начала прохождения теста или другого действия
                },
                child: Text('Начать тест'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}