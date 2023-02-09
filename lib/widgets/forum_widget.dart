import 'package:campus_plus/controller/forum_controller.dart';
import 'package:campus_plus/model/answer_model.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/question_model.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/data_controller.dart';

class ForumWidget extends StatefulWidget {
  String chatId;

  ForumWidget({required this.chatId});

  @override
  _ForumWidgetState createState() => _ForumWidgetState(chatId: chatId);
}

class _ForumWidgetState extends State<ForumWidget> {
  String chatId;
  List<MyQuestion> myQuestions = List.empty(growable: true);
  TextEditingController questionController = TextEditingController();

  _ForumWidgetState({required this.chatId});

  late ForumController forumController;
  late DataController dataController;
  late CleanUser currentUser;

  @override
  void initState() {
    forumController = Get.put(ForumController());
    dataController = Get.put(DataController());
    currentUser = dataController.cleanUserInfo(dataController.getLocalData());
    getQuestions();
  }

  getQuestions() async {
    List<MyQuestion> temp = await forumController.getQuestions(chatId);
    setState(() {
      myQuestions = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        myQuestions.isEmpty ? noQuestionWidget() : questions(),
        Positioned(
          child: askQuestionButton(),
          bottom: 60,
        ),
      ],
    );
  }

  Widget noQuestionWidget() {
    return Center(
      child: Text(
        "There's no question yet. Be the first one to ask!",
        style: TextStyle(
          fontSize: 15,
          color: AppColors.genderTextColor,
        ),
      ),
    );
  }

  Widget askQuestionButton() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return askQuestionWidget();
            });
      },
      child: Text(
        ""
        "Ask a question!",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.grey),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))),
      ),
    );
  }

  Widget askQuestionWidget() {
    return Center(
      child: Container(
        height: 300,
        width: Get.width * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.03,
            ),
            Text(
              "Ask a question!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                child: TextFormField(
                  controller: questionController,
                  cursorColor: AppColors.aubRed,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Ask here...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                MyQuestion myQuestion = await forumController.postQuestion(
                    chatId, currentUser, questionController.text);
                setState(() {
                  myQuestions.add(myQuestion);
                });
                Navigator.pop(context);
              },
              child: Text(
                "Post",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.only(left: 25, right: 25)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white24),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget questions() {
    return ListView.builder(
      itemCount: myQuestions.length,
      itemBuilder: (context, index) {
        return questionCard(myQuestions[index]);
      },
    );
  }

  Widget questionCard(MyQuestion question) {
    TextEditingController answerController = TextEditingController();
    question.answers.sort((MyAnswer answer1, MyAnswer answer2) =>
        answer2.timePosted.compareTo(answer1.timePosted));
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: ExpansionTileCard(
          shadowColor: AppColors.aubRed,
          baseColor: AppColors.white2,
          title: Text(
            question.user.firstName + " " + question.user.lastName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          leading: UserProfilePicture(
            imageURL: question.user.profilePictureURL,
            caption: question.user.firstName,
            radius: 20,
            preview: false,
          ),
          subtitle: Text(
            question.question,
            style: TextStyle(fontSize: 14),
          ),
          //trailing: Text(question.timePosted.toString()),
          children: [
            question.answers.length > 0
                ? LayoutBuilder(builder: (context, constraints) {
                    return Container(
                        height: constraints.maxHeight > Get.height * 0.05
                            ? Get.height * 0.25
                            : constraints.maxHeight,
                        child: ListView.builder(
                            reverse: true,
                            itemCount: question.answers.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: Row(
                                        children: [
                                          UserProfilePicture(
                                            imageURL: question.answers[index]
                                                .user.profilePictureURL,
                                            caption: question
                                                .answers[index].user.firstName,
                                            radius: 15,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                question.answers[index].user
                                                        .firstName +
                                                    " " +
                                                    question.answers[index].user
                                                        .lastName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                width: 180,
                                                child: Text(
                                                  question
                                                      .answers[index].answer,
                                                  softWrap: true,
                                                  //overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            toDate(question
                                                .answers[index].timePosted),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            }));
                  })
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "No answers yet...\nBe the first one to answer!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                    ),
                  ),
            Container(
              margin: EdgeInsets.all(5),
              child: Material(
                  color: AppColors.white2,
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLines: 3,
                          minLines: 1,
                          controller: answerController,
                          cursorColor: AppColors.aubRed,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Answer here...",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            MyAnswer answer = forumController.postAnswer(
                                chatId,
                                currentUser,
                                question.questionId,
                                answerController.text);
                            setState(() {
                              question.answers.add(answer);
                            });
                          },
                          icon: Icon(
                            Icons.send,
                          ))
                    ],
                  )),
            )
          ],
        ));
  }

  String toDate(DateTime dateTime) {
    return dateTime.day.toString() +
        "/" +
        dateTime.month.toString() +
        "/" +
        dateTime.year.toString() +
        "\n" +
        dateTime.hour.toString() +
        ":" +
        dateTime.minute.toString();
  }
}
