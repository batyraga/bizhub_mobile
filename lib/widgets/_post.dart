import 'package:flutter/material.dart';

class PostComponent extends StatefulWidget {
  final String name;
  final String by;
  final String description;
  final String imagePath;
  final int favorited;
  final int viewed;
  const PostComponent(
      {super.key,
      required this.name,
      required this.by,
      required this.description,
      required this.imagePath,
      required this.favorited,
      required this.viewed});
  @override
  PostComponentState createState() => PostComponentState();
}

class PostComponentState extends State<PostComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.zero),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Text(
                  "NS",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              contentPadding: const EdgeInsets.all(0),
              title: Text(widget.by),
              subtitle: const Text('Ashgabat'),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(
                  height: 240,
                  // width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ));
                  },
                  image: NetworkImage(widget.imagePath)),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(widget.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  CustomIconButton(
                      color: Colors.red,
                      icon: Icons.favorite,
                      bgColor: Colors.red[50]!,
                      count: widget.favorited),
                  const SizedBox(
                    width: 6,
                  ),
                  CustomIconButton(
                      disabled: true,
                      icon: Icons.remove_red_eye_outlined,
                      count: widget.viewed),
                ]),
                const CustomIconButton(icon: Icons.open_in_new, onlyIcon: true),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final int count;
  final Color color;
  final bool onlyIcon;
  final Color bgColor;
  final bool disabled;
  const CustomIconButton(
      {super.key,
      required this.icon,
      this.count = 0,
      this.color = Colors.black,
      this.onlyIcon = false,
      this.bgColor = Colors.transparent,
      this.disabled = false});

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.disabled
            ? null
            : () {
                debugPrint("salam");
              },
        style: TextButton.styleFrom(
            backgroundColor: widget.bgColor,
            foregroundColor: Colors.black,
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0))),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.color,
                  size: 20,
                ),
                if (widget.onlyIcon == false)
                  const SizedBox(
                    width: 5,
                  ),
                if (widget.onlyIcon == false)
                  Text(
                    widget.count.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: widget.color),
                  )
              ],
            )));
  }
}
