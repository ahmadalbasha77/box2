import 'package:box_app/controller/auth/area_controller.dart';
import 'package:box_app/controller/auth/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/validation.dart';

class AreaWidget extends StatelessWidget {
  AreaWidget({super.key});

  final _controller = AreaController.to;
  final _controllerSignUp = SignUpController.to;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: (text) => Validation.isRequired(text),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        labelText: 'Select Area'.tr,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      value: _controllerSignUp.selectedAreaId.value,
      items: _controller.area
          .map((area) => DropdownMenuItem(
                value: area.id.toString(),
                child: Text(area.name),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          final selectedArea = _controller.area
              .firstWhere((bank) => bank.id.toString() == value);
          _controllerSignUp.setSelectedArea(value, selectedArea.name);
        }
      },
    );
  }
}
