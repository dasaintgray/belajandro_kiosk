import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  final String lottieFiles;
  const LoadingWidget({super.key, required this.lottieFiles});

  @override
  Widget build(BuildContext context) {
    return DotLottieLoader.fromAsset(
      lottieFiles,
      frameBuilder: (ctx, dotlottie) {
        if (dotlottie != null) {
          return Lottie.memory(
            dotlottie.animations.values.single,
            fit: BoxFit.contain,
          );
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }
}
