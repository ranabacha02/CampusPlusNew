import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:get/get.dart';
import '../controller/post_controller.dart';
import '../controller/data_controller.dart';
import '../model/post_model.dart';
import '../model/user_model.dart';
import '../widgets/main_post.dart';
import 'anonymous_form_screen.dart';
import 'package:campus_plus/views/notifications.dart';
import 'package:campus_plus/views/schedule.dart';


class AnonymousPostsScreen extends StatefulWidget {
  const AnonymousPostsScreen({super.key});

  @override
  _AnonymousPostsScreenState createState() => _AnonymousPostsScreenState();
}

enum TagsFilter { study, food, fun, sports}

class _AnonymousPostsScreenState extends State<AnonymousPostsScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late DataController dataController;
  late PostController postController;
  late final MyUser userInfo;
  late Future<List<MyPost>> futurePosts;
  final List<String> _tags = <String>[];

  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
    postController = Get.put(PostController());
    userInfo = dataController.getLocalData();
    futurePosts = gettingPosts();
  }

  Future<List<MyPost>> gettingPosts() async {
    return await postController.getAllVisiblePosts();
  }

  Future<void> refreshPosts() async {
    final newPosts = gettingPosts();
    final filteredPosts = postController.filterPosts(await newPosts, _tags);
    setState(() {
      futurePosts = filteredPosts;
    });
  }

  Future<void> updatePage() async {
    final newPosts = gettingPosts();
    final filteredPosts = postController.filterPosts(await newPosts, _tags);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      futurePosts = filteredPosts;
    });
  }

  Wrap buildTagFilterChip() {
    return Wrap(
      spacing: 5.0,
      children: TagsFilter.values.map((TagsFilter tag){
        return FilterChip(
            label: Text(tag.name),
            selected: _tags.contains(tag.name),
            onSelected: (bool value){
              setState(() {
                if (value) {
                  if (!_tags.contains(tag.name)) {
                    _tags.add(tag.name);
                  }
                } else {
                  _tags.removeWhere((String name) {
                    return name == tag.name;
                  });
                }
              });
            }
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              "CAMPUS+",
              style: TextStyle(
                fontSize: 30,
                color: AppColors.aubRed,
              ),
            ),
            elevation: 0,
            actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const MainPostForm();
                      }),
                    );
                    refreshPosts();
                  },
                  icon: Image.asset('assets/postIcon.png')),
              IconButton(
                  onPressed: () => {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const Schedule();
                      })
                  )},
                  icon: Image.asset('assets/calendarIcon.png')),
              IconButton(
                  onPressed: () => { Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return Notifications();
                      })
                  )},
                  icon: Image.asset('assets/notificationIcon.png')),
            ]),
        body: Container(
            color: Colors.white,
            child: FutureBuilder(
              future: futurePosts,
              builder: (context, snapshot){
                return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: updatePage,
                    child: _listView(snapshot, userInfo, refreshPosts, buildTagFilterChip)
                );
              },
            )
        )
    );
  }
}

Widget _listView(AsyncSnapshot snapshot, MyUser userInfo, Function refreshPosts, Function buildTagFilterChip) {
  if(!snapshot.hasData){
    return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }
  final posts = snapshot.data;
  return
    Column(
        children: [
          const SizedBox(height:20),
          buildTagFilterChip(),
          Expanded(child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index){
              if(posts[index].createdBy == userInfo.userId){
                return MainPost(
                  post: posts[index],
                  personal: true,
                  refreshPosts: refreshPosts,
                );}
              else{
                return MainPost(
                  post: posts[index],
                  personal: true,
                  refreshPosts: refreshPosts,
                );}
            },
          )),
        ]
    );
}


