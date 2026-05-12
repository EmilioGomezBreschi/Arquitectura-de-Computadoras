import sys
import re

R_FUNCT = {
    "add": "100000",
    "sub": "100010",
    "and": "100100",
    "or":  "100101",
    "slt": "101010",
}

I_OPCODE = {
    "addi": "001000",
    "subi": "001001",
    "andi": "001100",
    "ori":  "001101",
    "slti": "001010",
    "lw":   "100011",
    "sw":   "101011",
    "beq":  "000100",
    "bne":  "000101",
    "bgtz": "000111",
}

J_OPCODE = {
    "j": "000010",
}

def to_bin(value, bits):
    value = int(value)
    if value < 0:
        value = (1 << bits) + value
    if value < 0 or value >= (1 << bits):
        raise ValueError(f"Valor fuera de rango para {bits} bits: {value}")
    return format(value, f"0{bits}b")

def reg_to_bin(reg):
    reg = reg.strip().replace("$", "").replace("r", "").replace("R", "")
    if not reg.isdigit():
        raise ValueError(f"Registro invalido: {reg}")
    num = int(reg)
    if num < 0 or num > 31:
        raise ValueError(f"Registro fuera de rango: ${num}")
    return to_bin(num, 5)

def clean_line(line):
    line = line.split("#")[0]
    line = line.split("//")[0]
    return line.strip()

def split_instruction(line):
    line = line.replace(",", " ")
    line = line.replace("(", " ")
    line = line.replace(")", " ")
    return line.split()

def first_pass(lines):
    labels = {}
    instructions = []
    pc = 0

    for line in lines:
        line = clean_line(line)
        if not line:
            continue

        while ":" in line:
            label, rest = line.split(":", 1)
            label = label.strip()
            if not label:
                raise ValueError("Etiqueta vacia encontrada")
            labels[label] = pc
            line = rest.strip()

        if line:
            instructions.append(line)
            pc += 1

    return labels, instructions

def encode_r(parts):
    op = parts[0].lower()

    if op == "nop":
        return "00000000000000000000000000000000"

    if len(parts) != 4:
        raise ValueError(f"Instruccion R invalida: {' '.join(parts)}")

    rd = reg_to_bin(parts[1])
    rs = reg_to_bin(parts[2])
    rt = reg_to_bin(parts[3])
    shamt = "00000"
    funct = R_FUNCT[op]
    opcode = "000000"

    return opcode + rs + rt + rd + shamt + funct

def encode_i(parts, labels, pc):
    op = parts[0].lower()
    opcode = I_OPCODE[op]

    if op in ["addi", "subi", "andi", "ori", "slti"]:
        if len(parts) != 4:
            raise ValueError(f"Instruccion I invalida: {' '.join(parts)}")

        rt = reg_to_bin(parts[1])
        rs = reg_to_bin(parts[2])
        imm = to_bin(int(parts[3]), 16)

        return opcode + rs + rt + imm

    if op in ["lw", "sw"]:
        if len(parts) != 4:
            raise ValueError(f"Instruccion memoria invalida: {' '.join(parts)}")

        rt = reg_to_bin(parts[1])
        imm = to_bin(int(parts[2]), 16)
        rs = reg_to_bin(parts[3])

        return opcode + rs + rt + imm

    if op in ["beq", "bne"]:
        if len(parts) != 4:
            raise ValueError(f"Instruccion branch invalida: {' '.join(parts)}")

        rs = reg_to_bin(parts[1])
        rt = reg_to_bin(parts[2])
        label = parts[3]

        if label not in labels:
            raise ValueError(f"Etiqueta no encontrada: {label}")

        offset = labels[label] - (pc + 1)
        imm = to_bin(offset, 16)

        return opcode + rs + rt + imm

    if op == "bgtz":
        if len(parts) != 3:
            raise ValueError(f"Instruccion bgtz invalida: {' '.join(parts)}")

        rs = reg_to_bin(parts[1])
        rt = "00000"
        label = parts[2]

        if label not in labels:
            raise ValueError(f"Etiqueta no encontrada: {label}")

        offset = labels[label] - (pc + 1)
        imm = to_bin(offset, 16)

        return opcode + rs + rt + imm

    raise ValueError(f"Instruccion I no soportada: {op}")

def encode_j(parts, labels):
    op = parts[0].lower()

    if len(parts) != 2:
        raise ValueError(f"Instruccion J invalida: {' '.join(parts)}")

    target = parts[1]

    if target in labels:
        address = labels[target]
    else:
        address = int(target)

    return J_OPCODE[op] + to_bin(address, 26)

def encode_instruction(line, labels, pc):
    parts = split_instruction(line)

    if not parts:
        return None

    op = parts[0].lower()

    if op in R_FUNCT or op == "nop":
        return encode_r(parts)

    if op in I_OPCODE:
        return encode_i(parts, labels, pc)

    if op in J_OPCODE:
        return encode_j(parts, labels)

    raise ValueError(f"Instruccion no soportada: {op}")

def main():
    if len(sys.argv) < 2:
        print("Uso: python decoder.py programa.asm")
        return

    input_file = sys.argv[1]
    output_file = "codigo_binario.txt"

    with open(input_file, "r", encoding="utf-8") as file:
        lines = file.readlines()

    labels, instructions = first_pass(lines)

    binary_lines = []

    for pc, instruction in enumerate(instructions):
        binary = encode_instruction(instruction, labels, pc)
        binary_lines.append(binary)

    with open(output_file, "w", encoding="utf-8") as file:
        for binary in binary_lines:
            file.write(binary + "\n")

    print(f"Archivo generado correctamente: {output_file}")
    print(f"Instrucciones decodificadas: {len(binary_lines)}")

if __name__ == "__main__":
    main()