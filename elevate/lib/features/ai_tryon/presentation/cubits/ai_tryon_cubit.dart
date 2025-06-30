import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'ai_tryon_state.dart';
import '../../data/services/ai_tryon_service.dart';

class AITryOnCubit extends Cubit<AITryOnState> {
  AITryOnCubit({required this.productImage, required this.customerID})
    : super(AITryOnInitial());

  final String productImage;
  final String customerID;
  final TryOnService _tryOnService = TryOnService();
  String? customerUploadedImageURL;
  String? resultImageURL;

  List<CameraDescription>? _cameras;
  CameraController? _controller;

  List<CameraDescription>? get cameras => _cameras;
  CameraController? get controller => _controller;

  // Initialize the camera and set up the controller
  Future<void> initializeCamera() async {
    emit(AITryOnLoading());
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![1],
          ResolutionPreset.veryHigh,
          enableAudio: false,
        );
        await _controller!.initialize();
        emit(CameraInitialized());
      } else {
        emit(AITryOnFailure('No cameras available'));
      }
    } catch (e) {
      emit(AITryOnFailure('Failed to initialize camera: $e'));
    }
  }

  // Switch between front and back cameras
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2 || _controller == null) {
      return;
    }

    try {
      final currentCamera = _controller!.description;
      CameraDescription newCamera;

      if (currentCamera == _cameras![0]) {
        newCamera = _cameras![1];
      } else {
        newCamera = _cameras![0];
      }

      await _controller!.dispose();
      _controller = CameraController(
        newCamera,
        ResolutionPreset.veryHigh,
        enableAudio: false,
      );

      await _controller!.initialize();
      emit(CameraSwitched());
    } catch (e) {
      emit(AITryOnFailure('Failed to switch camera: $e'));
    }
  }

  // Take a picture using the camera
  Future<void> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      emit(AITryOnFailure('Camera not initialized'));
      return;
    }

    try {
      emit(AITryOnLoading());

      // Capture the image
      final XFile imageFile = await _controller!.takePicture();

      // Convert XFile to File
      final File file = File(imageFile.path);

      // Upload the image to Firebase Storage
      await uploadSelectedImage(file);
    } catch (e) {
      emit(AITryOnFailure('Failed to take picture: $e'));
    }
  }

  // Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      emit(AITryOnLoading());

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      final File file = File(image!.path);

      // Upload the selected image to Firebase Storage
      await uploadSelectedImage(file);
    } catch (e) {
      emit(AITryOnFailure('Failed to pick image from gallery: $e'));
    }
  }

  // Upload the image to Firebase Storage
  Future<void> uploadSelectedImage(File selectedImage) async {
    try {
      // Upload the image to Firebase Storage
      customerUploadedImageURL = await _tryOnService.uploadImage(
        customerID,
        selectedImage,
      );
      emit(PictureUploaded());
    } catch (e) {
      emit(AITryOnFailure("Failed to upload customer image: $e"));
    }
  }

  Future<void> tryOnProduct() async {
    if (customerUploadedImageURL == null) {
      emit(AITryOnFailure('No image uploaded'));
      return;
    }

    try {
      emit(AITryOnLoading());

      final tryOnResponse = await _tryOnService.tryOnRequest(
        productImage,
        customerUploadedImageURL!,
        'upper_body',
        customerID,
      );

      if (tryOnResponse == true) {
        emit(AITryOnSuccess());

        // Listen for the completed try-on result from Firebase Realtime Database
        _tryOnService
            .listenToTryOnStatus(customerID)
            .listen(
              (resultUrl) {
                if (resultUrl != null) {
                  resultImageURL = resultUrl;
                  emit(AITryOnResultReady());
                }
              },
              onError: (error) {
                emit(
                  AITryOnFailure('Error listening for try-on result: $error'),
                );
              },
            );
      } else {
        emit(AITryOnFailure('Failed to process try-on request'));
      }
    } catch (e) {
      emit(AITryOnFailure('Error during try-on: $e'));
    }
  }

  void disposeCamera() {
    _controller?.dispose();
    _controller = null;
    _cameras = null;
  }

  @override
  Future<void> close() {
    disposeCamera();
    return super.close();
  }
}
