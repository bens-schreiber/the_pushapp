import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class CameraDialog extends StatelessWidget {
  const CameraDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final cameras = snapshot.data as List<CameraDescription>;
            return _CameraDialog(cameras: cameras);
          }
          return const SizedBox.shrink();
        });
  }
}

class _CameraDialog extends HookWidget {
  final List<CameraDescription> cameras;
  const _CameraDialog({required this.cameras});

  @override
  Widget build(BuildContext context) {
    final cameraIndex = useState(0);
    final cameraController = useState<CameraController?>(null);

    initCamera() async {
      final controller = CameraController(
        cameras[cameraIndex.value],
        ResolutionPreset.medium,
      );

      await controller.initialize();
      cameraController.value = controller;
    }

    takePhoto() async {
      final image = await cameraController.value!.takePicture();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(image.path);
    }

    useEffect(() {
      initCamera();
      return () {
        cameraController.value!.dispose();
      };
    }, const []);

    if (cameraController.value == null ||
        !cameraController.value!.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final camera = Center(
      child: AspectRatio(
        aspectRatio: 1 / cameraController.value!.value.aspectRatio,
        child: CameraPreview(cameraController.value!),
      ),
    );

    final takePhotoButton = InkWell(
      onTap: takePhoto,
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final flipCamera = IconButton(
      icon: const Icon(
        Icons.flip_camera_ios,
        size: 45,
      ),
      onPressed: () {
        cameraIndex.value = (cameraIndex.value + 1) % cameras.length;
        initCamera();
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          camera,
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: takePhotoButton,
          ),
          Positioned(bottom: 80, right: 20, child: flipCamera)
        ],
      ),
    );
  }
}
