import re

from dataclasses import dataclass

from pyeda.inter import *


def Eq(a, b):
    return (a ^ b).unor()


def Bin(a, length=None):
    if length is None:
        length = len(a.replace("0b",""))
    return uint2exprs(int(a.replace("0b",""), 2), length)


def Vec(a, hi, lo=None):
    if lo is None:
        lo = hi
    return a[lo : hi + 1]

@dataclass
class PLA:
   outputs = {}

   def addOutput(self, name, eq):
      if name in self.outputs:
         self.outputs[name] = Or(self.outputs[name],
                              eq) 
      else:
         self.outputs[name] = eq 
   
   def generateTables(self):
      tables = {}
      for key, value in self.outputs.items():
         s = ""
         for match in re.finditer(r"And\(.*?\)",str(espresso_exprs(value.to_dnf()))):
            m = str(match.group())
            m=m.replace("And(","").replace(")","")
            terms = m.split(", ")
            processed_terms = {}
            for term in reversed(terms):
               signal = re.match(r"~?(\w+)\[(\d+)\]", term)
               if term[0] == "~":
                  processed_terms[int(signal.group(2))] = 0
               else:
                  processed_terms[int(signal.group(2))] = 1
            for n in reversed(range(32)):
               if n in processed_terms:
                  s += str(processed_terms[n])
               else:
                  s += '-'
            s += "\n"
         tables[key] = s
      return tables

   def toPla(self):
      truth_tables = {}
      for output in self.outputs:
         truth_tables[output] = str(expr2truthtable(self.outputs[output].to_dnf())).split("\n")

      output_iter = iter(zip(truth_tables))
      lines = next(output_iter)

      print(f".i {len(lines[0].split())}")
      print(f".o {len(lines)}")
      print(f".ilb {lines[0].replace('[','_').replace(']','')}")
      print(f".ob {self.outputs.keys()}")
      print(f".type fr")
      #for line, line2 in illegal_iter:
      #    print(f"{line.replace(' ', '').replace(':', ' ')}{line2[-1]}")
      print(f".e")