from pyeda.inter import *


def Eq(a, b):
    return (a ^ b).unor()


def Bin(a, length=None):
    if length is None:
        length = len(a)
    return uint2exprs(int(a, 2), length)


def Vec(a, hi, lo=None):
    if lo is None:
        lo = hi
    return a[lo : hi + 1]


d = exprvars("data", 16)

outputs = {}
outputs["illegal"] = Or(
    Eq(Vec(d, 15, 0), exprzeros(16)),
    And(
        Eq(Vec(d, 15, 13), Bin("000")),
        Eq(Vec(d, 12, 5), Bin("00000000")),
        Eq(Vec(d, 1, 0), Bin("00")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("100")),
        Eq(Vec(d, 1, 0), Bin("00")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("011")),
        Eq(Vec(d, 12), Bin("0")),
        Eq(Vec(d, 6, 2), Bin("00000")),
        Eq(Vec(d, 1, 0), Bin("01")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("100")),
        Eq(Vec(d, 12), Bin("1")),
        Eq(Vec(d, 11, 10), Bin("11")),
        Eq(Vec(d, 6, 5), Bin("10")),
        Eq(Vec(d, 1, 0), Bin("01")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("100")),
        Eq(Vec(d, 12), Bin("1")),
        Eq(Vec(d, 11, 10), Bin("11")),
        Eq(Vec(d, 6, 5), Bin("11")),
        Eq(Vec(d, 1, 0), Bin("01")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("010")),
        Eq(Vec(d, 11, 7), Bin("00000")),
        Eq(Vec(d, 1, 0), Bin("10")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("100")),
        Eq(Vec(d, 12), Bin("0")),
        Eq(Vec(d, 11, 7), Bin("00000")),
        Eq(Vec(d, 6, 2), Bin("00000")),
        Eq(Vec(d, 1, 0), Bin("10")),
    ),
)
outputs["illegal2"] = Or(
    Eq(Vec(d, 15, 0), exprzeros(16)),
    And(
        Eq(Vec(d, 15, 13), Bin("100")),
        Eq(Vec(d, 12), Bin("1")),
        Eq(Vec(d, 11, 10), Bin("11")),
        Eq(Vec(d, 6, 5), Bin("10")),
        Eq(Vec(d, 1, 0), Bin("01")),
    ),
    And(
        Eq(Vec(d, 15, 13), Bin("100")),
        Eq(Vec(d, 12), Bin("1")),
        Eq(Vec(d, 11, 10), Bin("11")),
        Eq(Vec(d, 6, 5), Bin("11")),
        Eq(Vec(d, 1, 0), Bin("01")),
    ),
)

illegal_iter = iter(
    zip(
        str(expr2truthtable(outputs["illegal"].to_dnf())).split("\n"),
        str(expr2truthtable(outputs["illegal2"].to_dnf())).split("\n"),
    )
)
line, line2 = next(illegal_iter)
print(f".i {len(line.split())}")
print(f".o 2")
print(f".ilb {line.replace('[','_').replace(']','')}")
print(f".ob illegal illegal2")
print(f".type fr")
for line, line2 in illegal_iter:
    print(f"{line.replace(' ', '').replace(':', ' ')}{line2[-1]}")
print(f".e")
