import re

import ruamel.yaml as yaml

from pyeda.inter import *

import PLA

isa_file = ""
for line in open('submodules/riscv-isa-data/opcodes.yaml'):
   if re.match(r"^isa:.*$",line):
      break
   isa_file += line

isa = yaml.safe_load(isa_file)

pla = PLA.PLA()
last_main_desc = ""
last_main_id = ""
for op_key, op_info in isa["opcodes"].items():
   if re.match(r"^\@",op_key):
      continue
   if "main_desc" in op_info:
      last_main_desc = op_info["main_desc"]
   if "main_id" in op_info:
      last_main_id = op_info["main_id"]
   if last_main_desc == "rv32" or last_main_desc == "c":
      #print(f"{op_key} - {last_main_id}")
      data = exprvars("data", 32)

      #Generate equation for op
      equation = expr(1)
      for opcode in [x for x  in op_info["opcode"] if re.match(r"\d+(?:\.\.\d+)?=",x)]:
         #Skip ignore
         if re.search(r"ignore",opcode):
            continue
         #Equals hex
         elif re_opcode := re.search(r"(\d+)(?:\.\.(\d+))?=0x(.*)",opcode):
            a = int(re_opcode.group(1))
            if re_opcode.group(2) is None:
               b = a
            else:
               b = int(re_opcode.group(2))
            c = int(re_opcode.group(3),16)
            equation = And(equation,
               PLA.Eq(PLA.Vec(data, a, b), PLA.Bin(bin(c),a-b+1)),
                   )
         #Equals decimal
         elif re_opcode := re.search(r"(\d+)(?:\.\.(\d+))?=(.*)",opcode):
            a = int(re_opcode.group(1))
            if re_opcode.group(2) is None:
               b = a
            else:
               b = int(re_opcode.group(2))
            c = int(re_opcode.group(3))
            equation = And(equation,
               PLA.Eq(PLA.Vec(data, a, b), PLA.Bin(bin(c),a-b+1)),
                   )

      #Flag defined
      pla.addOutput("defined",equation)

      #Process different opcodes
      for opcode in [x for x  in op_info["opcode"] if not re.match(r"\d+(?:\.\.\d+)?=",x)]:
         if opcode == "#":
            break
         #print(opcode)
         pla.addOutput(opcode,equation)


#Ignore illegal op
pla.outputs["defined"] = And(pla.outputs["defined"],
                             Not(PLA.Eq(PLA.Vec(data, 15, 0), PLA.Bin("0",16)))) 

#print(pla.outputs)
#print()
#print(espresso_exprs(pla.outputs["defined"].to_dnf()))
#print()
for table, lines in pla.generateTables().items():
   print(table)
   print(lines)