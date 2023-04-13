import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Comencemos...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                ),
              ),
              Stack(
                children: [
                  // Positioned(
                  //   bottom: 0,
                  //   left: 0,
                  //   right: 0,
                  //   child: SizedBox(
                  //     height: 80,
                  //     width: size.width,
                  //     child: WaveHalfOval(
                  //         width: size.width + 100,
                  //         height: 80,
                  //         color: Colors.deepPurple),
                  //   ),
                  // ),
                  SizedBox(
                    height: size.height * 0.2,
                    child: Hero(
                        tag: 'ia',
                        child: Image.asset('assets/img/ia.gif',
                            fit: BoxFit.cover)),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

//CustomPainter para dibujar el circulo

class WaveHalfOval extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const WaveHalfOval({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  _WaveHalfOvalState createState() => _WaveHalfOvalState();
}

class _WaveHalfOvalState extends State<WaveHalfOval>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _WaveHalfOvalPainter(
            color: widget.color,
            animationValue: _animation.value,
          ),
        );
      },
    );
  }
}

class _WaveHalfOvalPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _WaveHalfOvalPainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final waveHeight = size.height * 0.2;
    final waveWidth = size.width * 0.8;
    final waveOffset = waveWidth * 0.4;
    final waveMidpoint = rect.bottomCenter - Offset(0, waveHeight);
    final controlPointOffset = Offset(waveOffset, waveHeight * animationValue);

    final path = Path()
      ..moveTo(rect.left, rect.bottom)
      ..lineTo(rect.left, waveMidpoint.dy)
      ..quadraticBezierTo(
        waveMidpoint.dx - controlPointOffset.dx,
        waveMidpoint.dy - controlPointOffset.dy,
        waveMidpoint.dx,
        waveMidpoint.dy,
      )
      ..quadraticBezierTo(
        waveMidpoint.dx + controlPointOffset.dx,
        waveMidpoint.dy + controlPointOffset.dy,
        rect.right,
        waveMidpoint.dy,
      )
      ..lineTo(rect.right, rect.bottom)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WaveHalfOvalPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue;
  }
}
