import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> lstNewsInfo = [];
  @override
  void initState() {
    super.initState();
    getNewsInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff424242),
        title: const Text(
          '🚬HeadLine News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: lstNewsInfo.length,
        itemBuilder: (context, index) {
          var newsItem = lstNewsInfo[index];
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  //이미지
                  SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: newsItem['urlToImage'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              newsItem['urlToImage'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset('assets/noimage.png'),
                          ),
                  ),
                  //반투명 검정 UI
                  Container(
                    width: double.infinity,
                    height: 57,
                    decoration: ShapeDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newsItem['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formatDate(newsItem['publishedAt']),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///하얀색 뉴스 제목 , 일자 텍스트
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: newsItem);
            },
          );
        },
      ),
    );
  }

  String formatDate(String dateString) {
    //시간 문자열 값을 원하는 형식으로 변환해주는 유틸 메소드 함수
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM,dd HH:mm');
    return formatter.format(dateTime);
  }

  Future getNewsInfo() async {
    //뉴스 정보를 가지고 오는 api 활용
    const apiKey = 'e1b96ae95307480193e0ba88aa894bab';
    const apiUrl =
        'https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey';

    try {
      // 네트워크 통신을 요청하고 with response 변수에 결과 값이 저장된다.
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        //200 -> result Ok
        final Map<String, dynamic> responseData = json.decode(response.body);

        setState(() {
          lstNewsInfo = responseData['articles'];
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print(error);
    }
  }
}
