# dskrbt

As Simple as Possible CD/ DVD Disk Changer Robot

`This is a work in progress`

#### License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US">Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License</a>.

#### Project sources

- https://github.com/0xPIT/dskrbt
- http://www.thingiverse.com/thing:97291

### What?

I intend to archive all of my several hundred audio CDs to gain shelf space. So I try to build a small robot capable of changing the disks that

- uses as few parts as possible
- can be built from cheap, standard or scrap-, plus some 3D printed parts
- is of small size so that it can be stowed away easily

![Status](http://thingiverse-production.s3.amazonaws.com/renders/82/27/06/aa/85/P1020512_2_preview_featured.jpg)
![Status](http://thingiverse-production.s3.amazonaws.com/renders/7f/3d/3c/7c/c6/P1020511_preview_featured.jpg)

### Design

Like most commercial units, I believe that a beam with a grabber mechanism should work best and helps to get a rather small unit. I was thinking about a suitable mechanism for grabing, that is easy to build but found no satisfactory solution. There's a project available using a carved wooden grabber with a solenoid, but thats too fragile in my opinion, also probably heavy. After finding cheap industrial vacuum cups on ebay (10€), I decided to go with that.

#### Parts used (so far)

- 8mm rod from old printer
- GT2 timing belt from old scanner for Z axis
- smaller GT2 timing belt for X (rotational) axis
- 3D-printed belt pulleys
  - find several openscad pulleys on thingiverse
- ball bearings, one flanged (F688ZZ), one normal (608)
- tiny ball bearing pressed into the idler pulley
- 3D-printed bearing holder (inside enclosure)
- cheapo aluminum enclosure
- industrial vacuum cup with spring [ebay](http://www.ebay.de/itm/160774763977) + [ebay](http://www.ebay.de/itm/160776083251)
- two stepper motors from old scanners
  - Mitsumi M35SP-7N, 4 Ohms, set to ~500mA
  - Motor pinions fit GT2 belt
- [Crumbuino](http://chip45.de/products/crumbuino-nano_arduino_compatible_atmega328_module_board_usb.php), similar to an Arduino Nano
- 2 pololu / StepStick stepper controller [ebay](http://www.ebay.de/itm/280877891763)
- [grbl](https://github.com/grbl/grbl) 0.9x to control the beast

### Issues & Todo

- Find a nice, simple way to sense that the arm has arrived at the stack of CDs while moving down the z-axis. 
  - The vacuum cup has a spring, probably add some optical or hall sensor to detect when the spirng engages? (could be too much force, though)

- Homing
  - X-Axis: Add a magnet on the motor and a Hall Sensor
  - Z-Axis: Hall or optical?

- Modify grbl and add a G-Code (M66?) so that, while picking up or dropping of a disc the arm's z-axis can move an arbitrary distance, depending on the size of stack of discs left to pick up or already dropped off.
 
- Need a method on how to detect the presence of a disk. Current draft idea is to use CNY70 refelctive optical sensor. Should simply trigger an interrrupt and send some short ascii token via the serial connection.

- The linear bearing (LM8UU) does not like the forces indiced by the changer arm and sometimes gets stuck. This is probably due to my bearing being a cheap chinese type. Use a brass or sintered bronce bearing?

- In order to save parts and a second rod, I intended the arm to be stabilized rotationally only by the belt. this is very inaccurate, the arm wiggles. could work, though.

- The vacuum cup just needs a pneumatic solenoid valve to hold a CD, i.e. no vacuum is necessary, but it wont hold for long. Therefore, I plan to use a tiny vacuum pump nevertheless.


### Status

- 2013-05-30
    - completed mechanical prototype
- 2013-05-31
  - tested mechanics with grbl. works nicely. Set motors to ~500mA each.
  - messed with the cables: fried avr and pololus (got 12V on VDD)
  - Ordered replacements




