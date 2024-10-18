import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CachedStreamHandler<T> extends HookWidget {
  final String id;
  final Stream<T> Function() stream;
  final Widget Function(
    BuildContext,
    T?,
    void Function() refetch,
  ) builder;
  final double defaultHeight;

  const CachedStreamHandler({
    super.key,
    required this.id,
    required this.stream,
    required this.builder,
    this.defaultHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    final data = useStream(stream(), initialData: null);

    return Builder(
      builder: (context) {
        if (data.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: defaultHeight,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          );
        }

        if (data.hasError) {
          if (kDebugMode) {
            print('Something Went Wrong When Getting data from Stream');
            print(data.error);
          }
          return SizedBox(
            height: defaultHeight,
            child: GestureDetector(
              onTap: () => data.requireData, // Trigger refetch logic for stream
              child: const Center(
                child: Text('Something Went Wrong'),
              ),
            ),
          );
        }

        return builder(context, data.data, () => data.requireData);
      },
    );
  }
}
