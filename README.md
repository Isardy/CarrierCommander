# Carrier Commander (Avorion)

A very small server-side Avorion mod that adds:

- a new captain type: **Carrier Commander**
- a Fighter Factory bulletin variant of **A Lost Friend** that rewards a **Tier 3 Carrier Commander**

## Files

- `modinfo.lua`: required Avorion mod metadata
- `main.lua`: global script entrypoint
- `data/scripts/lib/captainclass.lua`: registers `CarrierCommander` class id
- `data/scripts/lib/captainutility.lua`: adds class display/name/description
- `data/scripts/entity/utility/captainshipbonuses.lua`: applies in-flight carrier bonuses
- `data/scripts/entity/missionbulletins.lua`: injects Carrier Commander Lost Friend into Fighter Factory mission pool
- `data/scripts/player/missions/receivecarriercommander.lua`: bulletin generator for the Fighter Factory Lost Friend variant

## Install (Linux)

1. Copy the `CarrierCommander` folder to:
   - `~/.avorion/mods/`
2. Start Avorion and open:
   - `Settings -> Mods`
3. Enable **Carrier Commander**.
4. Restart game/server if prompted.

## Test

- Dock at or interact with a **Fighter Factory** and check the bulletin board for **A Lost Friend**.
- Accepting that mission runs the normal Lost Friend flow and rewards a **Tier 3 Carrier Commander**.

## Customize

In `data/scripts/entity/utility/captainshipbonuses.lua`, change:

- fighter squad, pilot, pickup, and speed bonus values

## Admin Command

- `/givecarriercaptain [player] [tier] [level]`
- Assigns a Carrier Commander captain directly to the target player's active craft.
- `player` can be omitted to target yourself.
- `tier` range: `0-3` (default `3`), `level` range: `0-5` (default `2`).
- Command scripts must exist in Avorion's command folder to be recognized:
   - `.../Avorion/data/scripts/commands/givecarriercaptain.lua`

## Notes

- This mod runs on both server and client (`serverSideOnly = false`) so custom captain UI data (name/icons/tooltips) is visible.
- This mod is `saveGameAltering`.
- Captain internals differ between game versions and mods.
