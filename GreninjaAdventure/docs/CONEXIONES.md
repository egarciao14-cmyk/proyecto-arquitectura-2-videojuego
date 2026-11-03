# Conexiones

Todas las tierras deben estar unidas. La lógica del Arduino Due es **3.3 V**;
no aplique 5 V a ninguna entrada.

| Módulo | Señal | Arduino Due | SAM3X8E |
|---|---|---|---|
| ILI9341 | VCC | 3.3 V | - |
| ILI9341 | GND | GND | - |
| ILI9341 | SCK | SPI header SCK | PA27 / SPCK |
| ILI9341 | MOSI/SDI | SPI header MOSI | PA26 / MOSI |
| ILI9341 | MISO/SDO | SPI header MISO (opcional) | PA25 / MISO |
| ILI9341 | CS | D10 | PC29 |
| ILI9341 | DC/RS | D9 | PC21 |
| ILI9341 | RST | D8 | PC22 |
| Joystick | VRx | A0 | PA16 / AD7 |
| Joystick | VRy | A1 | PA24 / AD6 |
| Joystick | SW/Z | D2 y GND | PB25, pull-up interno |
| Pulsador | salto | D3 y GND | PC28, pull-up interno |

Si el módulo TFT incorpora regulador/level shifter, confirme su rotulado antes de
alimentarlo; este proyecto asume señales compatibles con 3.3 V. El LED de fondo
puede requerir resistencia o transistor según el módulo.
