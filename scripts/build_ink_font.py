"""Build the OFL-derived ink font. Development only: requires fonttools."""
import argparse
from copy import deepcopy
import math
from pathlib import Path
import random
import string


def build(source, output):
    from fontTools.ttLib import TTFont
    from fontTools.ttLib.tables._f_v_a_r import Axis
    from fontTools.ttLib.tables.TupleVariation import TupleVariation
    from fontTools.ttLib.tables import otTables
    from fontTools.otlLib.builder import buildAlternateSubstSubtable
    font = TTFont(source)
    font.ensureDecompiled()
    axis = Axis()
    axis.axisTag, axis.minValue, axis.defaultValue, axis.maxValue = "INKR", 0, 0, 100
    axis.flags = 0
    axis.axisNameID = font["name"].addName("Ink irregularity")
    font["fvar"].axes.append(axis)
    font["fvar"].instances = []
    def expand_regions(obj):
        if isinstance(obj, list):
            for child in obj:
                expand_regions(child)
        elif hasattr(obj, "__dict__"):
            if obj.__class__.__name__ == "VarRegionList":
                for region in obj.Region:
                    extra = otTables.VarRegionAxis()
                    extra.StartCoord = extra.PeakCoord = extra.EndCoord = 0
                    region.VarRegionAxis.append(extra)
                obj.RegionAxisCount = len(font["fvar"].axes)
            for child in vars(obj).values():
                if isinstance(child, list) or child.__class__.__module__.endswith("otTables"):
                    expand_regions(child)
    for tag in ("GDEF", "MVAR", "BASE", "GPOS", "GSUB"):
        if tag in font and hasattr(font[tag], "table"):
            expand_regions(font[tag].table)
    if "avar" in font:
        font["avar"].segments["INKR"] = {-1: -1, 0: 0, 1: 1}
    # Use gvar's phantom-point metrics for copied glyphs instead of stale HVAR IDs.
    for tag in ("HVAR", "VVAR"):
        if tag in font:
            del font[tag]
    order = list(font.getGlyphOrder())
    cmap = font.getBestCmap()
    mapping = {}
    for character in string.ascii_letters + string.digits:
        base = cmap[ord(character)]
        natives = [base] + [f"{base}.alt{i}" for i in range(1, 4)
                            if f"{base}.alt{i}" in font["glyf"]]
        mapping[base] = []
        for index in range(32):
            source_name = natives[index % len(natives)]
            glyph = deepcopy(font["glyf"][source_name])
            target = f"{base}.ink{index+1:02}"
            if glyph.isComposite():
                points = [(component.x, component.y) for component in glyph.components]
            else:
                points, _, _ = glyph.getCoordinates(font["glyf"])
            rng = random.Random(ord(character) * 1009 + index * 7919)
            phase = [rng.uniform(0, 2 * math.pi) for _ in range(4)]
            frequency = rng.uniform(1.2, 2.3) * math.pi / font["head"].unitsPerEm
            amplitude = rng.uniform(50, 72)
            # One smooth displacement field per glyph: nearby outline/control
            # points move coherently, rather than independent noisy vertices.
            delta = [(round(amplitude * (math.sin(y * frequency + phase[0])
                         + .35 * math.sin(x * frequency + phase[1]))),
                      round(amplitude * (.7 * math.sin(x * frequency + phase[2])
                         + .3 * math.sin(y * frequency + phase[3]))))
                     for x, y in points] + [(0, 0)] * 4
            font["glyf"][target] = glyph
            font["hmtx"][target] = font["hmtx"][source_name]
            if "vmtx" in font:
                font["vmtx"][target] = font["vmtx"][source_name]
            font["gvar"].variations[target] = deepcopy(font["gvar"].variations.get(source_name, []))
            font["gvar"].variations[target].append(
                TupleVariation({"INKR": (0, 1, 1)}, delta))
            order.append(target)
            mapping[base].append(target)
    font.setGlyphOrder(order)
    lookup = otTables.Lookup()
    lookup.LookupType, lookup.LookupFlag = 3, 0
    lookup.SubTable = [buildAlternateSubstSubtable(mapping)]
    lookup.SubTableCount = 1
    lookups = font["GSUB"].table.LookupList
    index = len(lookups.Lookup)
    lookups.Lookup.append(lookup)
    lookups.LookupCount = len(lookups.Lookup)
    for record in font["GSUB"].table.FeatureList.FeatureRecord:
        if record.FeatureTag == "aalt":
            record.Feature.LookupListIndex = [index]
            record.Feature.LookupCount = 1
    names = {1: "Iwroteit Ink", 2: "Regular", 3: "1.000;IWRT;IwroteitInk-Regular",
             4: "Iwroteit Ink Regular", 6: "IwroteitInk-Regular",
             16: "Iwroteit Ink", 17: "Regular", 25: "IwroteitInk"}
    for record in font["name"].names:
        if record.nameID in names:
            record.string = names[record.nameID].encode(record.getEncoding())
    font.save(output)
    print(f"{output}: 32 generated choices for each ASCII letter/digit; INKR 0-100")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    build(args.source, args.output)
