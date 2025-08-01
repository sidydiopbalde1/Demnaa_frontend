import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/create_favorite_place_controller.dart';

class CreateFavoritePlaceView extends GetView<FavoritePlaceController> {
  const CreateFavoritePlaceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreateFavoritePlaceView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreateFavoritePlaceView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
