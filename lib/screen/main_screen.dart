import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> lstNewsInfo = [];
  //admob
  late String admobBanenrId; // 하단 배너 id
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    getNewsInfo();
    //admob 세팅
    setAdmob();
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
                    Navigator.pushNamed(context, '/detail',
                        arguments: newsItem);
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(
              ad: _bannerAd,
            ),
          )
        ],
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

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //android
      if (kReleaseMode) {
        return 'ca-app-pub-2635737019072788/2076448434'; //release unit-id
      } else {
        return 'ca-app-pub-3940256099942544/9214589741'; //debug (test) unit-id
      }
    } else if (Platform.isIOS) {
      //ios
      if (kReleaseMode) {
        return ''; //release unit-id
      } else {
        return ''; //debug (test) unit-id
      }
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void setAdmob() {
    // admob 세팅
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            //광고 로드가 완료됨.
          });
        },
        onAdFailedToLoad: (ad, error) {
          print(error.message);
        },
      ),
      request: AdRequest(),
    );
    _bannerAd.load();
  }
}
