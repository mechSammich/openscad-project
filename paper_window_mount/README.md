# paper-window mount
This repo contains an openSCAD script that generates a 3D printable enclosure for the paper-window project electronic hardware.

## object context
The paper-window hardware includes a raspberry pi zero w with a waveshare e-paper display hat on the header pins in landscape orientation and a 5 way tact button interface board placed on the right hand side of the raspberry pi. See the image provided in the current directory. The assembly will be embedded into drywall such that the e-paper display is approximately flush with the surface of the wall.

## object directives
The paper-window mount shall:
1. provide mounting screw bosses for the raspberry pi and button board
2. align the joystick on the button board along the midpoint of the screen
3. feature a small bezel that will rest on the surface of the wall
4. provide passthroughs for the SD card, USB ports, and excess wiring bundle
5. provide clearly parameterized variables that allow fine tuning of:
    a. board mount offsets from bezel datum
    b. board mount hole spacing
    c. wall thickness