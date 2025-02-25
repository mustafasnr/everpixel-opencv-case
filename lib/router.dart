import 'package:go_router/go_router.dart';
import 'package:opencv_case/edit_image/edit_image_view.dart';
import 'package:opencv_case/image_select/image_select_view.dart';

GoRouter router = GoRouter(
  initialLocation: "/image_select",
  routes: [
    GoRoute(
      path: "/image_select",
      builder: (context, state) => const ImageSelectView(),
    ),
    GoRoute(
      path: "/edit_image",
      builder: (context, state) => const EditImageView(),
    ),
  ],
);
