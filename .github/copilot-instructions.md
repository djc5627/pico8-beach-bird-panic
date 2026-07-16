Repository context
------------------
This repository contains a Pico-8 cartridge project implemented in Lua. It's a top-down shoot 'em up: the player ship must survive and defeat waves of enemies. Game source is organized under `src/` (for example `main.lua`, `player.lua`, `enemy.lua`, `bullet.lua`, `starfield.lua`, etc.). Art resources are under `resources/` and the cartridge file is `beach_bird_panic.p8`.

How Copilot should help
-----------------------
- Prioritize Pico-8 constraints and idioms over generic Lua suggestions.
- Prefer small, token-efficient, and memory-conscious changes. Pico-8 enforces cartridge size/token limits and has very limited runtime memory compared to desktop Lua.
- Suggest code that fits into the existing `src/` layout and follows the project's style (simple modules and single-purpose files). When proposing new helper files or functions, place them in `src/` and reference them in `main.lua`.
- When adding API calls, stick to Pico-8 built-ins: `cls`, `spr`, `sfx`, `music`, `btn`, `btnp`, `pal`, `palt`, `map`, `mget`/`mset`, `_update()`, `_draw()`, `_init()`, `_update60()` when 60fps behavior is intended, etc.

Best-practice guidance (Lua, focused on Pico-8)
----------------------------------------------
- Use `local` everywhere possible. Globals are cheap in some Lua implementations but cost tokens and can cause name collisions in Pico-8. Prefer `local function` and `local` variables.
- Keep functions short and focused. Smaller functions reduce tokens and improve readability.
- Separate update and draw logic: put game state updates in `_update()` or `_update60()` and drawing-only code in `_draw()`.
- Favor numeric `for` loops for arrays (for i=1,#t do ...) instead of `ipairs` when you need speed and predictable behavior.
- Reuse tables/objects (object pooling) for frequently spawned entities (bullets, enemies) to avoid excessive GC pressure. Example: keep a `pool` table and flip an `active` flag instead of creating/dropping tables each frame.
- Precompute and store values you use often (sin/cos lookup, sprite indices) to avoid repeated calculations.
- Keep allocation of strings and tables to a minimum in the hot path. Avoid concatenating strings every frame for rendering; build the text once when it changes.

Pico-8 specific nuances and tips
--------------------------------
- Screen and sprite layout:
  - Pico-8 screen resolution is 128x128. Design UI and sprite placement to fit this canvas.
  - Sprite sheet and map tiles are limited; pack sprites thoughtfully into the 8x8 grid in the sprite sheet.
  - Use palette swapping (`pal`) and `palt` to avoid duplicating similar sprites.
- Input handling:
  - `btn()` checks continuous button state; `btnp()` is for single-press events. Use `btnp()` for actions like shooting or menu navigation, `btn()` for analog-like movement.
- Timing and frame rate:
  - Pico-8 calls `_update()` at 30 FPS by default. If you want 60 FPS behavior, implement `_update60()` (Pico-8 will call it instead). Be explicit about which update function you use.
  - Do not rely on floating deltatime — prefer fixed-step logic because Pico-8 runs at a fixed tick rate.
- Sound and music:
  - Use `sfx()` to play single SFX and `music()` for patterns. Keep sound effects short (Pico-8 SFX have limited length and channels).
- Memory and token limits:
  - Pico-8 cartridges have strict code/token and asset size limits. Keep code compact: use short local names in hot code, avoid big helper libraries unless token-cost is justified.
  - Inline small helper functions if it reduces tokens and improves readability.
- Drawing and performance:
  - Batch sprite draws sensibly; call `spr()` only when needed. Overdrawing can cost cycles.
  - Use `rectfill`/`circfill` sparingly if you can draw using sprites (or pre-render small background tiles on the map).
  - Use `stat(1)` / profiler primitives when debugging performance to find hot spots.

Style and project conventions
----------------------------
- Code layout: keep a single entry file `src/main.lua` that wires up the game, registers `_init`, `_update`/_update60, and `_draw`, and loads any modules in `src/`.
- Small modules: model each concept in its own file (`player.lua`, `enemy.lua`, `bullet.lua`, `starfield.lua`). Export a minimal table or set of functions and keep internal state local to the file.
- Prefer plain tables as objects and simple metatables or the included `class.lua` if the repo already uses one. Keep metatable usage lightweight.
- Use comments to explain magic numbers (sprite indices, speed constants, timing frames). Prefer named constants at the top of the file.

Common patterns to prefer
------------------------
- Object pooling for bullets/enemies rather than creating many short-lived tables.
- A single `update(dt)` pattern is fine conceptually; in practice use fixed-step logic (frame counters) to schedule waves and spawn timers.
- Input mapping: keep a small layer that translates `btn()`/`btnp()` into higher-level actions (left/right/shoot) so you can change controls in one place.
- Prefer compound assignment operators (`+=`, `-=`, etc.) for clarity and brevity when updating numeric state. They are supported by pico8 even if lua considers them as syntax errors.

Examples and quick snippets (illustrative only)
----------------------------------------------
- Use local modules:

  local M = {}

  local _player = {x=64,y=100}

  function M.update()
	-- update player
  end

  function M.draw()
	-- draw player
  end

  return M

- Pooling sketch for bullets:

  local bullets = {}
  for i=1,32 do bullets[i] = {active=false} end

  local function spawn_bullet(x,y,vx,vy)
	for i=1,#bullets do
	  local b = bullets[i]
	  if not b.active then
		b.active=true
		b.x=x b.y=y b.vx=vx b.vy=vy
		break
	  end
	end
  end

  -- iterate with numeric for loop for speed
  for i=1,#bullets do
	local b = bullets[i]
	if b.active then
	  b.x += b.vx
	  b.y += b.vy
	  -- deactivate if off-screen
	  if b.x<0 or b.x>128 or b.y<0 or b.y>128 then b.active=false end
	end
  end

Testing & iteration notes
-------------------------
- Test on the actual Pico-8 runtime or pico8-compatible web builds whenever possible. Desktop Lua may behave differently in terms of memory and available functions.
- Keep changes small and measurable: when optimizing, profile with `stat()` and test on slow hardware if possible.

When asking Copilot for changes
------------------------------
- Tell Copilot the target is `pico-8` and whether you intend `30` or `60` fps.
- Request compact patches: "suggest a minimal change to `src/player.lua` to use object pooling for bullets".
- Request code in-place edits to existing files, not new huge libraries. If a new helper file is necessary, prefer a single small `util.lua` or `pool.lua` in `src/`.

Tone and response style
----------------------
- Be pragmatic and concise. Prefer short code examples and minimal diffs.
- When suggesting code, include a brief one-line rationale for changes and note any Pico-8-specific tradeoffs (tokens, memory, frame budget).

Contact points in this repo
---------------------------
- Project entry: `src/main.lua`
- Player: `src/player.lua`
- Enemy: `src/enemy.lua`
- Bullets: `src/bullet.lua`
- Sprites & art: `resources/SpaceShooter.png` and `resources/SpaceShooter.aseprite`
- Cartridge: `beach_bird_panic.p8`

If you need clarification about which FPS target or token budget to optimize for, ask briefly and prefer 30 FPS optimizations unless the repository already uses `_update60()`.


