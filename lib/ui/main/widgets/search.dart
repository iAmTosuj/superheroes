import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:superheroes/blocs/main_bloc/main_cubit.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  SearchWidget() {
    controller.addListener(() {
      Get.find<MainCubit>().searchSuperheroes(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return TextField(
          controller: controller,
          cursorColor: Colors.white,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              suffix: GestureDetector(
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 24,
                ),
                onTap: () {
                  controller.clear();
                },
              ),
              filled: true,
              fillColor: SuperheroesColors.indigo75,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white54,
                size: 24,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: state.haveSearchText
                      ? BorderSide(color: Colors.white, width: 2)
                      : BorderSide(color: Colors.white24))),
        );
      },
    );
  }
}
