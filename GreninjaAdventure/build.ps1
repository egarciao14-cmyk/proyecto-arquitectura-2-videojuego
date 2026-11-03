$ErrorActionPreference = 'Stop'
$project = 'greninja_adventure'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$build = Join-Path $root 'build'
$tool = if ($env:ARM_GCC_PATH) { $env:ARM_GCC_PATH } else {
  'C:\Users\PAVILION\AppData\Local\Arduino15\packages\arduino\tools\arm-none-eabi-gcc\7-2017q4\bin'
}
$gcc = Join-Path $tool 'arm-none-eabi-gcc.exe'
$objcopy = Join-Path $tool 'arm-none-eabi-objcopy.exe'
$size = Join-Path $tool 'arm-none-eabi-size.exe'
if (-not (Test-Path $gcc)) { throw 'Set ARM_GCC_PATH to the GNU Arm Embedded bin directory.' }
New-Item -ItemType Directory -Force $build | Out-Null
$names = 'startup','clock','gpio','adc','spi','ili9341','timer','level','sprites','physics','hud','game'
$objects = @()
foreach ($name in $names) {
  $source = Join-Path $root "src\$name.S"
  $object = Join-Path $build "$name.o"
  & $gcc -mcpu=cortex-m3 -mthumb -x assembler-with-cpp -DBARE_METAL_BUILD "-I$(Join-Path $root 'src')" -Wall -Wextra -c $source -o $object
  if ($LASTEXITCODE) { throw "Assembly failed: $name.S" }
  $objects += $object
}
$elf = Join-Path $build "$project.elf"
$map = Join-Path $build "$project.map"
& $gcc -mcpu=cortex-m3 -mthumb -nostdlib '-Wl,--gc-sections' "-Wl,-Map=$map" "-T$(Join-Path $root 'linker.ld')" @objects -o $elf
if ($LASTEXITCODE) { throw 'Link failed.' }
& $objcopy -O binary $elf (Join-Path $build "$project.bin")
& $objcopy -O ihex $elf (Join-Path $build "$project.hex")
& $size $elf
