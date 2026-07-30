# TODO

## Important
- [X] Enemy brains
  - [X] Smarter enemy (player can stay still and not die)
- [X] Add starfish enemy
  - [X] Jumps up, matches player y position, then shoots left

- [ ] Enemy Behaviors
  - [X] Move at velocity
  - [X] Move towards player (doFollowX, doFollowY)
  - [X] Wait
  - [X] Interrupt brain commands and go to next command
  - [ ] Shoot
  - [ ] Command to wait for player LOS (to interrupt to shoot) takes angle LOS

- [ ] Better player shooting
- [ ] Bullet Splat
- [ ] Bullet Stamina Meter
- [ ] Shoot Slower when empty
- [ ] Press O to shoot all bullets at once
- [ ] Press O to do barrel roll dodge? or Parry?
- [ ] pick secondary attach via upgrades?
- [ ] Slower, more deliberate combat
- [ ] Bullets carry some momentum?

- [ ] XP System
  - [ ] Add XP bar to HUD
  - [ ] Add XP gain on enemy death
  - [ ] Add level up system
  - [ ] Add player stat upgrades on level up

## Less Important
- [ ] Collision with ground
- [ ] Refactor explosion code
  - [ ] Separate generic particle code from explosion code
  - [ ] Split tools like rndrange()
- [ ] Parallax effect
  - [ ] Second sand layer that scrolls slower
  - [ ] Second tree layer that scrolls slower
- [ ] Player flash frames update while freeze-frame
- [ ] Fix sounds too low/high in pitch for miyoo mini to play
  - [ ] Player shoot sound
