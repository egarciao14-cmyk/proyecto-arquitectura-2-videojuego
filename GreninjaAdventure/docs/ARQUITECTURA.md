# Arquitectura

## Flujo

Tras reset, `startup.s` copia `.data`, limpia `.bss`, configura el reloj a 84 MHz
y arranca GPIO, ADC, SPI0, ILI9341 y TC0. TC0 genera `CPCS` a aproximadamente 60 Hz;
su ISR reconoce la interrupción y publica `tick_flag`. El lazo principal sólo
actualiza una vez por tick.

Estados: `MENU -> PLAY -> GAME_OVER`. Z inicia; en Game Over Z regresa al menú.
En Game Over no se llama a la física, por lo que el mundo queda detenido.

## Representación y reglas

- Coordenadas enteras en píxeles; origen arriba a la izquierda.
- Jugador 14x18; velocidad horizontal de 2 px/tick.
- Impulso de salto -9, gravedad +1 y caída máxima 8 px/tick.
- Aterrizaje por cruce de la cara superior de una plataforma.
- Zona muerta de joystick: 350..673 sobre ADC de 10 bits.
- Colores RGB565 y orientación ILI9341 horizontal 320x240.

## Registros y periféricos

No hay llamadas a Arduino ni controladores externos. Las direcciones de PMC,
PIO, ADC, SPI, TC y NVIC están centralizadas en `src/sam3x8e.inc`. La tabla de
vectores reside al inicio de flash en 0x00080000 y la RAM en 0x20070000.

## Limitaciones conocidas de esta entrega

El PDF original citado en la conversación no estaba adjunto al espacio de trabajo,
por lo que no se pudo cotejar una rúbrica adicional más allá de los requisitos del
mensaje. El movimiento de enemigos y la copia mutable de monedas deben validarse
en la primera compilación/prueba; el esqueleto modular y los datos están incluidos.
