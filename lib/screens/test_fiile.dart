import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';

class TestFile extends StatefulWidget {
  const TestFile({Key? key}) : super(key: key);

  @override
  State<TestFile> createState() => _TestFileState();
}

class _TestFileState extends State<TestFile> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
            appBar: AppBar(
              title: const Text('GeeksforGeeks'),
              backgroundColor: Colors.greenAccent[400],
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
              child: Center(
                child: Column(
                  children: [
                  Card(
                  elevation: 50,
                  shadowColor: Colors.black,
                  color: Colors.greenAccent[100],
                  child: SizedBox(
                    width: 310,
                    height: 510,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                      CircleAvatar(
                      backgroundColor: Colors.green[500],
                        radius: 108,
                        child: const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
                          //NetworkImage
                          radius: 100,
                        ),
                      ),
                     const SizedBox(
                        height: 10,
                      ), //SizedBox
                      Text(
                        'GeeksforGeeks',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                     const SizedBox(
                        height: 10,
                      ), //SizedBox
                      Text(
                        'GeeksforGeeks is a computer science portalfor geeks at geeksforgeeks.org. It contains well written, well thought and well explained computer science and programming articles, quizzes, projects, interview experiences and much more!!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green[900],
                      ),
                    ),
                   const  SizedBox(
                      height: 10,
                    ), //SizedBox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () => null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ) ,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: const [
                                  Icon(Icons.touch_app),
                                  Text('Visit'),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Favourite Button
                        FavoriteButton(
                          isFavorite: false,
                          valueChanged: (_isFavorite) {
                            print('Is Favorite : $_isFavorite');
                          },
                        ),
                      ],
                    ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: Colors.yellowAccent[100],
              child: SizedBox(
                width: 310,
                height: 510,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                  CircleAvatar(
                  backgroundColor: Colors.yellow[700],
                    radius: 108,
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
                      //NetworkImage
                      radius: 100,
                    ),
                  ),
                 const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'GeeksforGeeks',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.yellow[900],
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                 const SizedBox(
                    height: 10,
                  ), //SizedBox
                  Text(
                    'GeeksforGeeks is a computer science portalfor geeks at geeksforgeeks.org. It contains well written, well thought and well explained computer science and programming articles, quizzes, projects, interview experiences and much more!!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.yellow[900],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow[600],
                        ) ,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: const[
                              Icon(Icons.touch_app),
                              Text('Visit'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Favourite Button
                    FavoriteButton(
                      isFavorite: true,
                      valueChanged: (_isFavorite) {
                        print('Is Favorite : $_isFavorite');
                      },
                    ),
                  ],
                ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    ),
    ),
    );



  }
}
