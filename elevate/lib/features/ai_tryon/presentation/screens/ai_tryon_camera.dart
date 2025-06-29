import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/ai_tryon_cubit.dart';
import '../cubits/ai_tryon_state.dart';
import 'ai_tryon_preview_page.dart';

class AITryonCamera extends StatelessWidget {
  const AITryonCamera({
    super.key,
    required this.productImage,
    required this.customerID,
  });

  final String productImage;
  final String customerID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AITryOnCubit(productImage: productImage, customerID: customerID)
                ..initializeCamera(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'AI Try-On Camera',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<AITryOnCubit, AITryOnState>(
          listener: (context, state) {
            if (state is AITryOnFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            } else if (state is PictureUploaded) {
              // Navigate to the image preview page
              final currentCubit = context.read<AITryOnCubit>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider<AITryOnCubit>.value(
                        value: currentCubit,
                        child: const AITryonPreviewPage(),
                      ),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<AITryOnCubit>();

            if (state is AITryOnLoading ||
                cubit.controller == null ||
                !cubit.controller!.value.isInitialized) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Processing...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Camera preview with 3:4 aspect ratio
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRect(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width:
                                cubit.controller!.value.previewSize?.height ??
                                1,
                            height:
                                cubit.controller!.value.previewSize?.width ?? 1,
                            child: CameraPreview(cubit.controller!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Bottom controls
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.photo_library_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          onPressed: () {
                            cubit.pickImageFromGallery();
                          },
                        ),
                      ),
                      // Capture button
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () => cubit.takePicture(),
                        ),
                      ),
                      // Switch camera button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.black,
                            size: 24,
                          ),
                          onPressed: () => cubit.switchCamera(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
