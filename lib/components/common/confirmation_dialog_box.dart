import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ConfirmationDialogBox extends StatelessWidget {
  final void Function() onYesPressed;

  const ConfirmationDialogBox({super.key, required this.onYesPressed});

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.15,
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onYesPressed,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: kPrimaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Check if the navigator can pop
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: kPrimaryColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
