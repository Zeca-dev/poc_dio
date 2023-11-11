import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poc_dio/dio_http.dart';
import 'package:poc_dio/web_view/web_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POC DIO'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    final dio = dioInstance();

                    final response = await dio.get('todos/').then(
                          (value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppWebView(
                                  title: 'App Web View',
                                  url: 'https://pub.dev/',
                                  messageError: 'Esta é uma mensagem de erro!'),
                            ),
                          ),
                        );

                    // log(response.data);
                  } catch (error) {
                    log(error.toString());
                  }
                },
                child: const Text('GET')),
          ],
        ),
      ),
    );
  }
}
