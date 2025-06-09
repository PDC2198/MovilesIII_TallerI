import 'package:flutter/material.dart';

class Moviescreen extends StatefulWidget {
  const Moviescreen({super.key});

  @override
  State<Moviescreen> createState() => _MoviescreenState();
}

class _MoviescreenState extends State<Moviescreen> {
  bool isPlaying = false;
  double volume = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reproducción de Películas'),automaticallyImplyLeading: false,),
      body: Column(
        children: [
          // Simulación del reproductor de video
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black87,
              child: Center(
                child: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  color: Colors.white70,
                  size: 80,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Barra de progreso simulada
          Slider(
            value: 0.3,
            onChanged: null, // deshabilitado
            activeColor: Colors.redAccent,
            inactiveColor: Colors.white54,
          ),

          const SizedBox(height: 10),

          // Controles de reproducción
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 36,
                onPressed: () {}, // No funcional por ahora
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 48,
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 36,
                onPressed: () {}, // No funcional por ahora
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Control de volumen
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.volume_down),
              Slider(
                value: volume,
                min: 0,
                max: 1,
                onChanged: (value) {
                  setState(() {
                    volume = value;
                  });
                },
                activeColor: Colors.redAccent,
                inactiveColor: Colors.grey,
                divisions: 10,
              ),
              const Icon(Icons.volume_up),
            ],
          ),

          const SizedBox(height: 20),

          // Opciones adicionales
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _optionButton(Icons.subtitles, 'Subtítulos'),
                _optionButton(Icons.high_quality, 'Calidad'),
                _optionButton(Icons.settings, 'Ajustes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.grey[700]),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
