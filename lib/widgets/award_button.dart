import 'package:flutter/material.dart';

class AwardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int awardCount;

  const AwardButton({Key? key, required this.onPressed, required this.awardCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 16),
            SizedBox(width: 4),
            Text(
              'Award',
              style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            if (awardCount > 0) ...[
              SizedBox(width: 4),
              Text(
                awardCount.toString(),
                style: TextStyle(color: Colors.amber),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
