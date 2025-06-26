import 'package:elevate/features/search/presentation/cubits/filter/filter_cubit.dart';
import 'package:elevate/features/search/presentation/cubits/filter/filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/size_config.dart';
import 'filter_button.dart';
import '../../../camera/presentation/screens/camera.dart';

class FiltersRow extends StatelessWidget {

  const FiltersRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterButton(
        label: 'Category',
        filterOptions: 2,
        isHighlighted: false,
        onFetch: () async {
          await context.read<FilterCubit>().getAllBrands();
        },
      ),
        SizedBox(width: 6* SizeConfig.horizontalBlock,),
        FilterButton(
          label: 'Brand',
          filterOptions: 1,
          isHighlighted: false,
          onFetch: () async {
            await context.read<FilterCubit>().getAllBrands();
          },
        ),
        SizedBox(width: 6* SizeConfig.horizontalBlock,),

        FilterButton(
          label: 'Dep',
          filterOptions: 3,
          isHighlighted: false,
          onFetch: () async {
            await context.read<FilterCubit>().getAllDepartments();
          },
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Camera()),
            );
          },
          child: Icon(Icons.image_outlined, size: 24 * SizeConfig.verticalBlock),
        ),
        SizedBox(width: 10 * SizeConfig.horizontalBlock),
        Icon(Icons.compare_arrows_outlined, size: 24 * SizeConfig.verticalBlock),
        // SizedBox(width: 10 * SizeConfig.horizontalBlock),
        // Icon(Icons.filter_alt_outlined, size: 26 * SizeConfig.verticalBlock),
      ],
    );
  }
}