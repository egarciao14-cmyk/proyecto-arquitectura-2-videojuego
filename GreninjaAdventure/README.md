# Greninja Adventure

Videojuego de plataformas 2D bare-metal para Arduino Due (SAM3X8E Cortex-M3),
escrito completamente en ensamblador ARM Thumb-2. No usa Arduino API, C/C++ ni
bibliotecas gráficas. El arte es geométrico/pixel-art original: no incluye assets
de Mario, Pokémon ni otros juegos.

## Funciones

- Menú de inicio; Z comienza la partida.
- Joystick X camina, D3 salta, gravedad y colisiones con plataformas.
- Nivel original, monedas, marcador y tres vidas.
- Game Over congela la física; Z vuelve al menú y permite reiniciar.
- ILI9341 manejada directamente por SPI0 y GPIO.
- Bucle lógico de 60 Hz gobernado por TC0 y su interrupción NVIC.

## Compilación

### Arduino IDE (recomendado)

1. Abra `GreninjaAdventure.ino` en Arduino IDE.
2. Instale y seleccione **Arduino SAM Boards (32-bits ARM Cortex-M3)**.
3. Seleccione **Arduino Due (Programming Port)** y el puerto correcto.
4. Pulse **Verificar** y después **Subir**.

El `.ino` sólo identifica el sketch. `src/arduino_entry.S` proporciona `setup()`
y `loop()` desde ensamblador; el resto del juego también está en archivos `.S`.
No se invoca ninguna función de Arduino. El core se usa únicamente para el
arranque, reloj y carga que Arduino IDE requiere.

### Compilación bare-metal independiente

Se requiere GNU Arm Embedded Toolchain (`arm-none-eabi-gcc`, `objcopy`, `size`):

```sh
make
```

En Windows también puede ejecutar `./build.ps1`; defina `ARM_GCC_PATH` si la
toolchain está en otra carpeta.

Produce `build/greninja_adventure.elf`, `.bin`, `.hex` y `.map`. Para cargar con
BOSSA, ponga la Due en modo programación y ejecute `make flash`.

## Estado de verificación

El código y mapa de memoria se prepararon para SAM3X8E. Se localizó la toolchain
incluida con Arduino IDE, pero Windows no pudo iniciar sus ejecutables antiguos
por una incompatibilidad de DLL. Por eso la compilación queda preparada pero no
certificada en este equipo. Use una versión actual de GNU Arm Embedded y siga
`docs/PRUEBAS.md`.

## Estructura

- `src/startup.S`: vector, inicialización de RAM y arranque bare-metal.
- `src/arduino_entry.S`: entrada para Arduino IDE.
- `src/clock.S`: reloj principal a 84 MHz y watchdog.
- `src/gpio.S`, `adc.S`, `spi.S`: periféricos por registros.
- `src/ili9341.S`: inicialización y primitivas RGB565.
- `src/timer.S`: TC0/NVIC, tick de 60 Hz.
- `src/physics.S`, `level.S`: gravedad, plataformas y contenido.
- `src/sprites.S`, `hud.S`: dibujo original y UI.
- `src/game.S`: estados, entrada, actualización y renderizado.

Consulte `docs/ARQUITECTURA.md`, `docs/CONEXIONES.md` y `docs/PRUEBAS.md`.
