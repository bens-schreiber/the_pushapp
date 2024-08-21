import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:the_pushapp/group/group_provider.dart";

class GroupPhotosDisplay extends ConsumerWidget {
  const GroupPhotosDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupPhotosAsync = ref.watch(groupPhotosProviderAsync);
    const loading = Center(child: CircularProgressIndicator());
    return groupPhotosAsync.when(
        data: (groupPhotos) => _GroupPhotosDisplay(groupPhotos),
        loading: () => loading,
        error: (error, stackTrace) => loading);
  }
}

class _GroupPhotosDisplay extends HookConsumerWidget {
  final List<String> groupPhotos;
  const _GroupPhotosDisplay(this.groupPhotos);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoIndex = useState(0);
    final controller = usePageController(initialPage: photoIndex.value);

    if (groupPhotos.isEmpty) {
      return const Text("No photos have been uploaded yet.");
    }

    useEffect(() {
      SharedPreferences.getInstance().then((prefs) {
        int lastIndex = prefs.getInt("photoIndex") ?? 0;
        photoIndex.value = lastIndex;

        // todo: fix
        Future.microtask(() {
          controller.jumpToPage(photoIndex.value);
        });
      });

      return () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("photoIndex", photoIndex.value);
      };
    }, []);

    final size = MediaQuery.of(context).size;

    final indexIndicator = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        groupPhotos.length,
        (index) => Container(
          height: 3,
          color: index == photoIndex.value ? Colors.white : Colors.grey,
          width: (size.width * (1 - 0.05 * (groupPhotos.length - 1))) /
              groupPhotos.length,
        ),
      ),
    );

    return Stack(
      children: [
        SizedBox(
          height: size.height,
          child: PageView.builder(
            controller: controller,
            itemCount: groupPhotos.length,
            onPageChanged: (index) {
              photoIndex.value = index;
            },
            itemBuilder: (context, index) {
              return Image.network(
                groupPhotos[index],
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        Positioned(top: 50, left: 0, right: 0, child: indexIndicator),
      ],
    );
  }
}
