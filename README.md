# Hi! Welcome to our project. May you find what you need.

## What CPU to use?
    
Definitely Z80. Many group is using it and the project run smoothly in Xilinx.


##  Opening the project

Just download this repository and open .xpr file. There will be some error. generating bitstream once and the error should dissappear.

## Programing the project

Put assembly in data.mem file. Data Should be 00 format in hex.

## Task

- Keyboard
    - [X] Keycode can be get through memory (0xFFFF and 0xFFFE)
    - [ ] Interrupt is implemented
    - [X] Show Keycode through Seven Segment
- Assembly program
    - [ ] Ball move logic
    - [ ] Bars move logic
    - [ ] Bouncing Mechanic logic
    - [ ] Update score logic
- VGA Mapping
    - [ ] show start screen
    - [X] show playing screen (Still mock. Position is hardcode)
    - [ ] show moving bars and ball
    - [ ] show score
- LED
    - [ ] show game state (Currently, used to show address of program )
   
##  Here are some link that may prove useful.
  
Z80 information in thai --> [link](http://z80.ctn-phrae.com/index.php?story=story-1.4)

Z80 OpenCore project --> [link](https://opencores.org/projects/a-z80)

Basys3 keyboard --> [link](https://reference.digilentinc.com/learn/programmable-logic/tutorials/basys-3-keyboard-demo/start)