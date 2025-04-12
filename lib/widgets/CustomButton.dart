import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color; // цвет фона
  final Color? textColor; // новый параметр: цвет текста
  final double? fontSize;
  final double? width;
  final double? height;
  final Color? borderColor; // новый параметр: цвет границы
  final double? borderWidth; // новый параметр: толщина границы

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor, // если null, будет цвет текста по умолчанию
    this.fontSize = 16.0,
    this.width,
    this.height,
    this.borderColor, // если null, границы не будет
    this.borderWidth = 1.0, // толщина по умолчанию
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.primaryColor,
          
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          side: borderColor != null 
              ? BorderSide(
                  color: borderColor!,
                  width: borderWidth!,
                  
                ) 
              : null, // граница (если borderColor не указан, будет null)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // радиус закругления
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor ?? theme.colorScheme.onPrimary, // цвет текста
          ),
        ),
      ),
    );
  }
}