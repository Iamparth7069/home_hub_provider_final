import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../../SettingScreen/Review/model/UserData.dart';
import '../Model/ChatRoomResModel.dart';
import '../controller/MessageScreenController.dart';
import 'chatscreen.dart';

class MessageScreen extends StatelessWidget {
  final MessegeController messageController = Get.put(MessegeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await messageController.getData();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Messages",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            _buildSearchBar(context),
            const SizedBox(height: 30),
            Expanded(
              child: GetBuilder<MessegeController>(
                builder: (_) {
                  final bool isSearch = _.isSearch.value;
                  final List<UserData> user = isSearch ? _.searchUserData.value : _.userDatas;
                  final List<ChatRoomResModel> chatdata = isSearch ? _.searchChatRooms : _.chatrooms;

                  if (_.isLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: appColor,
                        size: 40,
                      ),
                    );
                  }

                  if (user.isEmpty) {
                    return Center(
                      child: Text(
                        isSearch ? "Opps! No Data Found" : "No Chats Available",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: user.length,
                    itemBuilder: (context, index) {
                      final String hour = chatdata[index].lastChatTime.hour.toString().padLeft(2, '0');
                      final String minute = chatdata[index].lastChatTime.minute.toString().padLeft(2, '0');

                      return ListTile(
                        onTap: () {
                          Get.to(ChatScreen(chatdata[index], user[index], _.roomId[index]));
                        },
                        leading: _buildUserAvatar(user[index]),
                        title: Text(
                          "${user[index].firstName} ${user[index].lastName}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${chatdata[index].LastChat}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        trailing: Text(
                          "$hour:$minute",
                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    messageController.getSearchMesseges(searchValue: value.trim());
                    messageController.setSearchValue(value: true);
                  } else {
                    messageController.setSearchValue(value: false);
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Icon(Icons.search, color: Color(0xFF7165D6)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(UserData user) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: user.profileImage.isEmpty
            ? Image.asset(
          "assets/images/profile_image.jpg",
          fit: BoxFit.cover,
        )
            : CachedNetworkImage(
          imageUrl: user.profileImage,
          placeholder: (context, url) => LoadingAnimationWidget.hexagonDots(
            color: appColor,
            size: 3.h,
          ),
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/profile_image.jpg",
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
