import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  dynamic newsItem;
  DetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextButton(
          child: Text(
            '뒤로가기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //이미지
              SizedBox(
                height: 245,
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
              //제목
              Container(
                margin: EdgeInsets.only(top: 32),
                child: Text(
                  newsItem['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //일시
              Align(
                child: Text(
                  formatDate(newsItem['publishedAt']),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(
                height: 32,
              ),
              //섧명
              newsItem['description'] != null
                  ? Text(newsItem['description'])
                  : Text('내용없음'),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    //시간 문자열 값을 원하는 형식으로 변환해주는 유틸 메소드 함수
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('yyyy.MM,dd HH:mm');
    return formatter.format(dateTime);
  }
}
