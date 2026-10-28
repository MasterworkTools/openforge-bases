# scad-geometry-reviewer
verification: mutation — renders the touched entry files with openscad and reads the warnings; a finding cites the render that shows it.
**Checks:** positive geometry with no matching negative cut, non-manifold or empty STL output, geometry that ignores `height`/`square_basis` and hardcodes 6mm or inch values, undef reaching a transform or primitive.
**Spawn when:** the diff touches any `.scad` file that makes geometry (`lock_*.scad`, `impl_*.scad`, `connectors.scad`, `risers_*.scad`). Skip changes to comments only.
**Contents:** How the code is built · What to flag · How to prove it · Do not flag

You review OpenSCAD geometry for OpenForge bases.

## How the code is built

- `bases-*.scad` are customizer entry files. They set the globals (`LOCK`, `MAGNETS`, `MAGNET_HOLE`, `HEIGHT`, ...) and `include` one `impl_*.scad`.
- `impl_*.scad` includes `connectors.scad`, which includes every `lock_*.scad`.
- Each feature comes in pairs: `*_positive` modules are unioned into the base and `*_negative` modules are subtracted from it. The pattern at the top level is `difference() { union() { plain; positive } negative }`.
- A connector is chosen by string compare on `lock`/`magnets` inside `center_connector_*`, `joint_connector_*` and their `_wall_` variants.

## What to flag

1. **Unpaired positive/negative.** The diff adds a branch to a `*_positive` dispatcher (a new `lock == "..."` or `magnets == "..."` case) but not to the matching `*_negative` one, or the other way round. Check every variant: plain, `_wall_`, `_strip`, `_square`, curved, hex. A positive with no cut leaves a solid block, and the union of touching solids is where the non-manifold output comes from.
2. **Hardcoded dimensions.** A module takes `height`, `square_basis` or `magnet_hole` but its body uses a literal (6, 25.4, 3) where that value should go. Ask: does this still fit on an 8mm base or a 25mm basis?
3. **Undef into geometry.** A parameter without a default that a caller does not pass. OpenSCAD does not stop; it prints `Unable to convert ... undef` and silently drops the primitive, so a cut-out disappears with no error.
4. **Coplanar faces in a difference.** A negative whose face sits exactly on the positive's face (no overlap). Negatives should overshoot by a small pad (the code uses `bottom_pad = 1` and similar) so the cut breaks through.
5. **Positive and negative out of step.** The positive's footprint and the negative's placement use different offsets or sizes for the same feature, so the cut lands outside the block or leaves a wall thinner than 1mm.

## How to prove it

Render the entry files the change reaches, with the option that selects the new code turned on. One render takes about 5–20 seconds:

```bash
openscad -o /tmp/r.stl -D 'MAGNETS="snap_magnetic"' -D 'LOCK="openlock"' bases-square-wall.scad 2>&1 | grep -E 'WARNING|ERROR' | sort | uniq -c
```

- `Unable to convert ... undef` or `undefined operation` in a file the diff touched → finding 3.
- "Object may not be a valid 2-manifold" or an empty STL → findings 1 or 4.
- For finding 2, render at `-D HEIGHT=8` and look at the result (or compare volumes) next to the 6mm one.

Run `python3 tests/run.py <entry-file-name>` (or with no filter for all cases) and quote any FAIL lines; it compares volume, bbox, manifold status and warnings against `tests/golden.json`. Put the exact command in the finding so the author can run it again.

## Do not flag

- Warnings that also appear on the base commit for the same command. Note them once as pre-existing, at most.
- `$fn` choices, unless the diff makes a render take minutes.
- Style and naming. Typos in comments go to scad-plumbing-reviewer.
