import 'package:get/get.dart';

import '../controllers/article_detail_controllers.dart';

class ArticleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleDetailController());
  }
}
