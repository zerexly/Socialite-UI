import 'package:foap/helper/common_import.dart';

class CategoryAvatarType1 extends StatelessWidget {
  final CategoryModel category;
  final double? size;

  const CategoryAvatarType1({Key? key, required this.category, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: category.coverImage,
            fit: BoxFit.cover,
          ).overlay(Colors.black45),
          Positioned(
              bottom: 5,
              left: 5,
              right: 5,
              child: Text(
                category.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ))
        ],
      ),
    ).round(5);
  }
}
