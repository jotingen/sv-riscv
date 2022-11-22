import copy
import re

import yaml as yaml

from pyeda.inter import *

import PLA

isa_file = ""
for line in open("submodules/riscv-opcodes/instr_dict.yaml"):
    # if re.match(r"^isa:.*$",line):
    #   break
    isa_file += line

isa = yaml.safe_load(isa_file)

instructions = {}

output_file = open("src/riscv_decode.sv", "w")
output_function_file = open("tb/riscv_decode_fn.svh", "w")

pla = PLA.PLA()
#  last_main_desc = ""
#  last_main_id = ""
for inst, inst_fields in isa.items():
    # print(inst_fields)
    # print(inst_fields["extension"])
    # print(inst)
    extension_matched = False
    for extension in inst_fields["extension"]:
        if (
            extension.endswith("rv_c")
            or extension.endswith("rv32_c")
            or extension.endswith("rv_i")
            or extension.endswith("rv32_i")
            or extension.endswith("rv_m")
            or extension.endswith("rv32_m")
        ):
            extension_matched = True
    if not extension_matched:
        continue

    instructions[inst] = inst_fields

    # print(inst)

    # print(inst_fields["encoding"])

# Get full list of instructions and variable_fields
variable_fields = set()
for name, fields in instructions.items():
    for field in fields["variable_fields"]:
        variable_fields.add(field)


# Work on _n0 and _n2
instructions_processed = {}
for instr_out in sorted(instructions.keys()):
    data = exprvars("data", 32)
    eq = expr(1)
    for n, bit in enumerate(reversed(instructions[instr_out]["encoding"])):
        if bit == "1" or bit == "0":
            eq = And(PLA.Eq(PLA.Vec(data, n), PLA.Bin(bit)), eq)
    for field_out in instructions[instr_out]["variable_fields"]:
        if field_out.endswith("_n0"):
            if field_out.removesuffix("_n0") == "rd":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 11, 7), PLA.Bin("00000"))), eq)
            if field_out.removesuffix("_n0") == "rs1":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 19, 15), PLA.Bin("00000"))), eq)
            if field_out.removesuffix("_n0") == "rs2":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 24, 20), PLA.Bin("00000"))), eq)
            if field_out.removesuffix("_n0") == "rd_rs1":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 11, 7), PLA.Bin("00000"))), eq)
            if field_out.removesuffix("_n0") == "c_rs1":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 11, 7), PLA.Bin("00000"))), eq)
            if field_out.removesuffix("_n0") == "c_rs2":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 6, 2), PLA.Bin("00000"))), eq)
        if field_out.endswith("_n2"):
            if field_out.removesuffix("_n2") == "rd":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 11, 7), PLA.Bin("00010"))), eq)
            if field_out.removesuffix("_n2") == "rs1":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 19, 15), PLA.Bin("00010"))), eq)
            if field_out.removesuffix("_n2") == "rs2":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 24, 20), PLA.Bin("00010"))), eq)
            if field_out.removesuffix("_n2") == "rd_rs1":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 11, 7), PLA.Bin("00010"))), eq)
            if field_out.removesuffix("_n2") == "c_rs1":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 11, 7), PLA.Bin("00010"))), eq)
            if field_out.removesuffix("_n2") == "c_rs2":
                eq = And(Not(PLA.Eq(PLA.Vec(data, 6, 2), PLA.Bin("00010"))), eq)

    instruction_processed = copy.deepcopy(instructions[instr_out])
    instruction_processed["variable_fields"] = [
        variable_field.removesuffix("_n0").removesuffix("_n2")
        for variable_field in instruction_processed["variable_fields"]
    ]
    instruction_processed["encoding"] = []
    for match in re.finditer(r"And\(.*?\)", str(espresso_exprs(eq.to_dnf()))):
        s = ""
        m = str(match.group())
        m = m.replace("And(", "").replace(")", "")
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
                s += "-"
        instruction_processed["encoding"].append(s)

    instructions_processed[instr_out] = instruction_processed

# Filter out _n0 and _n2 fields now that theyve been processed
variable_fields = [
    variable_field
    for variable_field in variable_fields
    if not variable_field.endswith("_n0")
]
variable_fields = [
    variable_field
    for variable_field in variable_fields
    if not variable_field.endswith("_n2")
]

# make table
s = "module riscv_decode(\n"

s += "input logic [31:0] data,\n"

outputs = []
for instr_out in sorted(instructions_processed.keys()):
    outputs.append(f"output logic {instr_out.upper()}")
outputs.append(f"output logic defined")
outputs.append(f"output logic compressed")
for field_out in sorted(variable_fields):
    outputs.append(f"output logic {field_out}")
s += ",\n".join(outputs)

s += "\n);\n"

# make case for each output
# Instruction
for instr_out in sorted(instructions_processed.keys()):
    s += f"//{instr_out.upper()}\n"
    s += f"always_comb begin\n"
    s += f"casez (data[31:0])\n"
    encodings = []
    encodings.extend(instructions_processed[instr_out]["encoding"])
    encodings = [encoding.replace("-", "?") for encoding in encodings]
    encodings = ["32'b" + encoding + f": {instr_out.upper()} = '1;\n" for encoding in encodings]
    s += "".join(encodings)
    s += f"default: {instr_out.upper()} = '0;\n"
    s += f"endcase\n"
    s += f"end\n"

# Defined
s += f"//defined\n"
s += f"always_comb begin\n"
s += f"casez (data[31:0])\n"
encodings = []
for instr in sorted(instructions_processed.keys()):
    encodings.extend(instructions_processed[instr]["encoding"])
encodings = [encoding.replace("-", "?") for encoding in encodings]
encodings = ["32'b" + encoding + f": defined = '1;\n" for encoding in encodings]
s += "".join(encodings)
s += f"default: defined = '0;\n"
s += f"endcase\n"
s += f"end\n"

# Compressed
s += f"//compressed\n"
s += f"always_comb begin\n"
s += f"casez (data[31:0])\n"
encodings = []
for instr in sorted(instructions_processed.keys()):
    if instr.startswith("c_"):
        encodings.extend(instructions_processed[instr]["encoding"])
encodings = [encoding.replace("-", "?") for encoding in encodings]
encodings = ["32'b" + encoding + f": compressed = '1;\n" for encoding in encodings]
s += "".join(encodings)
s += f"default: compressed = '0;\n"
s += f"endcase\n"
s += f"end\n"

# Fields
for field_out in sorted(variable_fields):
    s += f"//{field_out}\n"
    s += f"always_comb begin\n"
    s += f"casez (data[31:0])\n"
    encodings = []
    for instr in sorted(instructions_processed.keys()):
        for encoding in instructions_processed[instr]["encoding"]:
            if field_out in instructions_processed[instr]["variable_fields"]:
                encodings.extend(instructions_processed[instr]["encoding"])
    encodings = [encoding.replace("-", "?") for encoding in encodings]
    encodings = ["32'b" + encoding + f": {field_out} = '1;\n" for encoding in encodings]
    s += "".join(encodings)
    s += f"default: {field_out} = '0;\n"
    s += f"endcase\n"
    s += f"end\n"

s += "endmodule\n"
output_file.write(s);


s=""
# make function for each output
# Instruction
for instr_out in sorted(instructions_processed.keys()):
    s += f"function automatic logic riscv_decode_{instr_out}(\n"
    s += "input logic [31:0] data\n"
    s += f");\n"
    s += f"logic {instr_out.upper()};\n"
    s += f"casez (data[31:0])\n"
    encodings = []
    encodings.extend(instructions_processed[instr_out]["encoding"])
    encodings = [encoding.replace("-", "?") for encoding in encodings]
    encodings = ["32'b" + encoding + f": {instr_out.upper()} = '1;\n" for encoding in encodings]
    s += "".join(encodings)
    s += f"default: {instr_out.upper()} = '0;\n"
    s += f"endcase\n"
    s += f"return {instr_out.upper()};\n"
    s += f"endfunction\n"

# Defined
s += f"function automatic logic riscv_decode_defined(\n"
s += "input logic [31:0] data\n"
s += f");\n"
s += f"logic defined;\n"
s += f"casez (data[31:0])\n"
encodings = []
for instr in sorted(instructions_processed.keys()):
    encodings.extend(instructions_processed[instr]["encoding"])
encodings = [encoding.replace("-", "?") for encoding in encodings]
encodings = ["32'b" + encoding + f": defined = '1;\n" for encoding in encodings]
s += "".join(encodings)
s += f"default: defined = '0;\n"
s += f"endcase\n"
s += f"return defined;\n"
s += f"endfunction\n"

# Compressed
s += f"function automatic logic riscv_decode_compressed(\n"
s += "input logic [31:0] data\n"
s += f");\n"
s += f"logic compressed;\n"
s += f"casez (data[31:0])\n"
encodings = []
for instr in sorted(instructions_processed.keys()):
    if instr.startswith("c_"):
        encodings.extend(instructions_processed[instr]["encoding"])
encodings = [encoding.replace("-", "?") for encoding in encodings]
encodings = ["32'b" + encoding + f": compressed = '1;\n" for encoding in encodings]
s += "".join(encodings)
s += f"default: compressed = '0;\n"
s += f"endcase\n"
s += f"return compressed;\n"
s += f"endfunction\n"

# Fields
for field_out in sorted(variable_fields):
    s += f"function automatic logic riscv_decode_{field_out}(\n"
    s += "input logic [31:0] data\n"
    s += f");\n"
    s += f"logic {field_out};\n"
    s += f"casez (data[31:0])\n"
    encodings = []
    for instr in sorted(instructions_processed.keys()):
        for encoding in instructions_processed[instr]["encoding"]:
            if field_out in instructions_processed[instr]["variable_fields"]:
                encodings.extend(instructions_processed[instr]["encoding"])
    encodings = [encoding.replace("-", "?") for encoding in encodings]
    encodings = ["32'b" + encoding + f": {field_out} = '1;\n" for encoding in encodings]
    s += "".join(encodings)
    s += f"default: {field_out} = '0;\n"
    s += f"endcase\n"
    s += f"return {field_out};\n"
    s += f"endfunction\n"

output_function_file.write(s);
