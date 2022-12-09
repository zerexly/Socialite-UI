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

class CategoryAvatarType2 extends StatelessWidget {
  final CategoryModel category;
  final double? size;

  const CategoryAvatarType2({Key? key, required this.category, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: category.coverImage,
          fit: BoxFit.cover,
          height: 30,
          width: 30,
        ).circular,
        const SizedBox(width: 10,),
        Text(
          category.name,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w700),
        )
      ],
    ).setPadding(left: 8,right: 8,top: 4,bottom: 4).borderWithRadius(context: context, value: 1, radius: 20);
  }
}
