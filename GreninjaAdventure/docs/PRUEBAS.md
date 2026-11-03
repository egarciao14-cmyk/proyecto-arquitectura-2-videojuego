# Plan de pruebas

## En PC (antes de grabar)

1. Instalar GNU Arm Embedded Toolchain y ejecutar `make clean && make`.
2. Confirmar que `arm-none-eabi-size` cabe holgadamente en 512 KiB flash/96 KiB RAM.
3. Revisar `build/greninja_adventure.map`: vector en 0x00080000 y stack al final de RAM.
4. Ejecutar `make disasm` y comprobar que sólo hay instrucciones Cortex-M3/Thumb-2.

## En hardware (pendientes)

1. Con TFT desconectada, confirmar 3.3 V y continuidad de GND.
2. Conectar según `CONEXIONES.md`; verificar menú horizontal sin parpadeo.
3. Pulsar Z: debe aparecer el nivel. Centro del joystick no debe mover; extremos sí.
4. Pulsar D3: salto sólo desde suelo/plataforma; comprobar gravedad y aterrizaje.
5. Recoger las cinco monedas y verificar marcador.
6. Tocar enemigos (tras habilitar/validar su actualización) y caer fuera del nivel;
   comprobar reducción de vidas.
7. Al llegar a cero: pantalla Game Over, física inmóvil; Z vuelve al menú.
8. Mantener funcionando 10 minutos y comprobar que no hay bloqueos ni calentamiento.

Use un analizador lógico si la TFT queda blanca: SCK debe rondar 14 MHz durante
transferencias, CS debe bajar, DC separar comandos/datos y RST tener pulso bajo.
