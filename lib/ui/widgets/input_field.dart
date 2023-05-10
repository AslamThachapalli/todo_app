import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes.dart';
import '/providers/theme_provider.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
              height: 52,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.only(left: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: widget == null ? false : true,
                      autofocus: false,
                      cursorColor:
                          Provider.of<ThemeProvider>(context).isLightMode
                              ? Colors.grey[700]
                              : Colors.grey[100],
                      style: subTitleStyle(context),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: subTitleStyle(context),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 0,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).backgroundColor,
                            width: 0,
                          ),
                        ),
                      ),
                      controller: controller,
                    ),
                  ),
                  widget == null ? Container() : Container(child: widget),
                ],
              ))
        ],
      ),
    );
  }
}
