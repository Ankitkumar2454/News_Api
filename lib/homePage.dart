import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_api/modals/fetchapi.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var values;
  Posts? newsposts;
  Future getDataFromJson() async {
    var client = http.Client();
    var url =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=b62307c648fc4317aed317989635f6ec';
    try {
      Response response = await client.get(Uri.parse(url));
      print(response.body);
      if (response.body != null) {
        setState(() {
          values = jsonDecode(response.body);
          newsposts = Posts.fromJson(values);
        });
      }
    } catch (e) {
      print(e);
    }
    // Posts newsposts = Posts.fromJson(values);
    // print(newsposts?.status);
    // print(newsposts?.articles[0].author);
    // print(newsposts?.totalResults);
  }

  @override
  void initState() {
    getDataFromJson();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var articleDetail;
    var source;
    var sitelink;
    return SafeArea(
      child: Scaffold(
        body: (values != null)
            ? PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsposts?.totalResults,
                itemBuilder: (context, index) {
                  articleDetail = newsposts?.articles[index];
                  source = newsposts?.articles[index].source;
                  sitelink = newsposts?.articles[index].url;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Colors.blue,
                                  Colors.pink
                                ], // Define your gradient colors
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "${source.name}",
                                style: TextStyle(
                                  fontFamily: "Google Sans",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              Text(
                                "Title : ${articleDetail!.title}",
                                style: TextStyle(
                                  fontFamily: "Google Sans",
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.015,
                              ),
                              Container(
                                child: (articleDetail!.urlToImage != null)
                                    ? Image.network(
                                        "${articleDetail.urlToImage}",
                                        height: 200,
                                        width: size.width,
                                        fit: BoxFit.cover,
                                        // color: Colors.red,
                                      )
                                    : Center(
                                        child: CircularProgressIndicator()),
                              ),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Author Name : ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${articleDetail!.author}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color:
                                              Color.fromARGB(255, 65, 3, 211),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.055,
                              ),
                              Text(
                                "Description :",
                                style: TextStyle(
                                  fontFamily: "Google Sans",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              (articleDetail!.description != null)
                                  ? Text(
                                      "${articleDetail!.description}",
                                      style: TextStyle(
                                        fontFamily: "Google Sans",
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 18,
                                        color: Color.fromARGB(255, 65, 3, 211),
                                      ),
                                    )
                                  : Text(" Description : Not Available"),
                              SizedBox(
                                height: size.height * 0.055,
                              ),
                              Text(
                                "Content :",
                                style: TextStyle(
                                  fontFamily: "Google Sans",
                                  fontWeight: FontWeight.bold,
                                  // fontSize: 18,
                                  // color: Color.fromARGB(255, 65, 3, 211),
                                ),
                              ),
                              (articleDetail!.content != null)
                                  ? Text(
                                      "${articleDetail!.content}",
                                      style: TextStyle(
                                        fontFamily: "Google Sans",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Text(" Content : Not Available"),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var url = sitelink;
                                  launchUrl(Uri.parse(url));
                                },
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: size.height * 0.036,
                                    width: size.width * 0.31,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(96),
                                      color: Color.fromARGB(255, 11, 3, 233),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Read more..',
                                        style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.025,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: [
                                    Text(
                                      "Published at  :",
                                      style: TextStyle(
                                        fontFamily: "Google Sans",
                                        fontWeight: FontWeight.bold,
                                        // fontSize: 18,
                                        // color: Color.fromARGB(255, 65, 3, 211),
                                      ),
                                    ),
                                    Text(
                                      " ${articleDetail!.publishedAt}",
                                      style: TextStyle(
                                        fontFamily: "Google Sans",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Color.fromARGB(255, 65, 3, 211),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
