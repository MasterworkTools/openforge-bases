#!/usr/bin/env python3
"""Render every case with openscad and compare against tests/golden.json.

Compares volume, bounding box, manifold status and the set of warnings, not
STL bytes, so a different triangulation of the same shape still passes.

  python3 tests/run.py            # check
  python3 tests/run.py --update   # accept current output as the new golden
  python3 tests/run.py bases-hex  # only cases whose name contains this
"""
import json, os, re, subprocess, sys, tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
GOLDEN = ROOT / "tests" / "golden.json"
OPENSCAD = os.environ.get("OPENSCAD", "openscad")

# name -> (file, {VAR: value}). Every entry file at its defaults, plus overrides.
CASES = {p.name: (p.name, {}) for p in sorted(ROOT.glob("bases-*.scad")) + sorted(ROOT.glob("risers_*.scad"))}
for f in ["bases-square.scad", "bases-wall-primary.scad"]:
    for m in ["magnetic", "snap_magnetic", "none"]:
        CASES[f"{f}[MAGNETS={m}]"] = (f, {"MAGNETS": m})
# Every wall texture in the customizer dropdown, so each texture's A blank is imported.
textures = re.search(r"^TEXTURE = .*// \[(.*)\]", (ROOT / "bases-wall-primary.scad").read_text(), re.M).group(1)
for t in textures.split(", "):
    CASES[f"bases-wall-primary.scad[TEXTURE={t}]"] = ("bases-wall-primary.scad", {"TEXTURE": t})
# Every entry file whose customizer offers snap_magnetic gets a snap case.
for p in sorted(ROOT.glob("bases-*.scad")):
    if ",snap_magnetic" in p.read_text():
        CASES.setdefault(f"{p.name}[MAGNETS=snap_magnetic]", (p.name, {"MAGNETS": "snap_magnetic"}))
CASES.update({f"unit/{p.name}": (f"tests/unit/{p.name}", {}) for p in sorted((ROOT / "tests" / "unit").glob("*.scad"))})


def stl_metrics(path):
    vol, lo, hi = 0.0, [float("inf")] * 3, [float("-inf")] * 3
    tri = []
    for line in open(path):
        line = line.split()
        if line and line[0] == "vertex":
            v = [float(x) for x in line[1:4]]
            lo, hi = [min(a, b) for a, b in zip(lo, v)], [max(a, b) for a, b in zip(hi, v)]
            tri.append(v)
            if len(tri) == 3:
                (ax, ay, az), (bx, by, bz), (cx, cy, cz) = tri
                vol += (ax * (by * cz - bz * cy) - ay * (bx * cz - bz * cx) + az * (bx * cy - by * cx)) / 6
                tri = []
    return round(abs(vol), 1), [round(x, 2) for x in lo + hi] if vol else []


def render(name):
    file, defines = CASES[name]
    with tempfile.TemporaryDirectory() as tmp:
        stl = Path(tmp) / "out.stl"
        args = [OPENSCAD, "-o", str(stl)]
        for k, v in defines.items():
            args += ["-D", f"{k}={json.dumps(v)}"]
        r = subprocess.run(args + [file], cwd=ROOT, capture_output=True, text=True, timeout=600)
        log = r.stdout + r.stderr
        if r.returncode or not stl.exists():
            return {"error": log.strip().splitlines()[-5:]}
        volume, bbox = stl_metrics(stl)
    return {
        "volume": volume,
        "bbox": bbox,
        "manifold": "2-manifold" not in log,
        "warnings": sorted({l.strip() for l in log.splitlines() if "WARNING" in l and "manifold" not in l}),
    }


def diff(want, got):
    if "error" in got:
        return [f"render failed: {got['error']}"]
    if want is None:
        return ["no golden entry (run with --update)"]
    out = []
    if abs(want["volume"] - got["volume"]) > 0.5:
        out.append(f"volume {want['volume']} -> {got['volume']}")
    if len(want["bbox"]) != len(got["bbox"]) or any(abs(a - b) > 0.01 for a, b in zip(want["bbox"], got["bbox"])):
        out.append(f"bbox {want['bbox']} -> {got['bbox']}")
    if want["manifold"] != got["manifold"]:
        out.append(f"manifold {want['manifold']} -> {got['manifold']}")
    out += [f"new warning: {w}" for w in got["warnings"] if w not in want["warnings"]]
    out += [f"warning gone: {w}" for w in want["warnings"] if w not in got["warnings"]]
    return out


def main():
    update = "--update" in sys.argv
    filters = [a for a in sys.argv[1:] if not a.startswith("--")]
    names = [n for n in CASES if not filters or any(f in n for f in filters)]
    golden = json.loads(GOLDEN.read_text()) if GOLDEN.exists() else {}
    with ThreadPoolExecutor(os.cpu_count()) as pool:
        results = dict(zip(names, pool.map(render, names)))

    failed = 0
    for name, got in results.items():
        problems = diff(golden.get(name), got)
        if update and "error" not in got:
            golden[name] = got
            problems = []
        if not got.get("manifold", True):
            print(f"  note {name}: non-manifold")
        if problems:
            failed += 1
            print(f"FAIL {name}\n    " + "\n    ".join(problems))
    if update:
        GOLDEN.write_text(json.dumps(dict(sorted(golden.items())), indent=1) + "\n")
    print(f"{len(results) - failed}/{len(results)} passed")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
