import sys
import re

REGISTERS = {
    "$zero": 0, "$0": 0,
    "$at": 1,
    "$v0": 2, "$v1": 3,
    "$a0": 4, "$a1": 5, "$a2": 6, "$a3": 7,
    "$t0": 8, "$t1": 9, "$t2": 10, "$t3": 11,
    "$t4": 12, "$t5": 13, "$t6": 14, "$t7": 15,
    "$s0": 16, "$s1": 17, "$s2": 18, "$s3": 19,
    "$s4": 20, "$s5": 21, "$s6": 22, "$s7": 23,
    "$t8": 24, "$t9": 25,
    "$k0": 26, "$k1": 27,
    "$gp": 28, "$sp": 29, "$fp": 30,
    "$ra": 31
}

R_FUNCT = {
    "add": 0x20,
    "sub": 0x22,
    "and": 0x24,
    "or":  0x25,
    "slt": 0x2A
}

I_OPCODE = {
    "addi": 0x08,
    "slti": 0x0A,
    "andi": 0x0C,
    "ori":  0x0D,
    "lw":   0x23,
    "sw":   0x2B,
    "beq":  0x04
}

J_OPCODE = {
    "j":   0x02,
    "jal": 0x03
}

DEFAULT_ASM = """inicio:
nop
addi $t0, $zero, 10
nop
nop

addi $s0, $zero, 4
nop
nop

add $t1, $t0, $s0
sub $t2, $t0, $s0
and $t3, $t0, $s0
or $t4, $t0, $s0
slt $t5, $s0, $t0
nop
nop

andi $t6, $t0, 3
ori $t7, $zero, 5
slti $t8, $zero, 10
nop
nop

sw $t0, 0($zero)
nop
nop

lw $t9, 0($zero)
nop
nop

jal funcion
nop
nop

funcion:
ori $s1, $zero, 7
nop
nop

beq $zero, $zero, etiqueta
nop
nop

etiqueta:
j inicio
"""


def reg_num(reg):
    reg = reg.strip().lower()

    if reg in REGISTERS:
        return REGISTERS[reg]

    if re.fullmatch(r"\$[0-9]+", reg):
        n = int(reg[1:])
        if 0 <= n <= 31:
            return n

    raise ValueError(f"Registro invalido: {reg}")


def clean_line(line):
    line = line.split("#")[0]
    line = line.split("//")[0]
    return line.strip()


def tokenize(line):
    line = line.replace(",", " ")
    line = line.replace("(", " ")
    line = line.replace(")", " ")
    return line.split()


def imm16(value, signed=True):
    # Acepta tanto strings como enteros
    if isinstance(value, int):
        value = value
    else:
        value = int(value, 0)

    if signed:
        if value < -32768 or value > 32767:
            raise ValueError(f"Inmediato fuera de rango: {value}")
    else:
        if value < 0 or value > 65535:
            raise ValueError(f"Inmediato fuera de rango: {value}")

    return value & 0xFFFF


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

            if label in labels:
                raise ValueError(f"Etiqueta repetida: {label}")

            labels[label] = pc
            line = rest.strip()

        if line:
            instructions.append(line)
            pc += 1

    return labels, instructions


def encode_r(parts):
    op = parts[0].lower()

    if op == "nop":
        return 0x00000000

    if len(parts) != 4:
        raise ValueError(f"Formato incorrecto para instruccion R: {' '.join(parts)}")

    rd = reg_num(parts[1])
    rs = reg_num(parts[2])
    rt = reg_num(parts[3])
    funct = R_FUNCT[op]

    opcode = 0
    shamt = 0

    return (
        (opcode << 26) |
        (rs << 21) |
        (rt << 16) |
        (rd << 11) |
        (shamt << 6) |
        funct
    )


def encode_i(parts, labels, pc):
    op = parts[0].lower()
    opcode = I_OPCODE[op]

    if op in ["addi", "slti"]:
        if len(parts) != 4:
            raise ValueError(f"Formato incorrecto para {op}: {' '.join(parts)}")

        rt = reg_num(parts[1])
        rs = reg_num(parts[2])
        immediate = imm16(parts[3], signed=True)

    elif op in ["andi", "ori"]:
        if len(parts) != 4:
            raise ValueError(f"Formato incorrecto para {op}: {' '.join(parts)}")

        rt = reg_num(parts[1])
        rs = reg_num(parts[2])
        immediate = imm16(parts[3], signed=False)

    elif op in ["lw", "sw"]:
        if len(parts) != 4:
            raise ValueError(f"Formato incorrecto para {op}: {' '.join(parts)}")

        rt = reg_num(parts[1])
        immediate = imm16(parts[2], signed=True)
        rs = reg_num(parts[3])

    elif op == "beq":
        if len(parts) != 4:
            raise ValueError(f"Formato incorrecto para beq: {' '.join(parts)}")

        rs = reg_num(parts[1])
        rt = reg_num(parts[2])
        label = parts[3]

        if label not in labels:
            raise ValueError(f"Etiqueta no encontrada: {label}")

        offset = labels[label] - (pc + 1)
        immediate = imm16(offset, signed=True)

    else:
        raise ValueError(f"Instruccion I no soportada: {op}")

    return (
        (opcode << 26) |
        (rs << 21) |
        (rt << 16) |
        immediate
    )


def encode_j(parts, labels):
    op = parts[0].lower()
    opcode = J_OPCODE[op]

    if len(parts) != 2:
        raise ValueError(f"Formato incorrecto para {op}: {' '.join(parts)}")

    target = parts[1]

    if target in labels:
        address = labels[target]
    else:
        address = int(target, 0)

        if address % 4 == 0:
            address = address // 4

    if address < 0 or address > 0x03FFFFFF:
        raise ValueError(f"Direccion J fuera de rango: {address}")

    return (
        (opcode << 26) |
        (address & 0x03FFFFFF)
    )


def encode_instruction(line, labels, pc):
    parts = tokenize(line)

    if not parts:
        raise ValueError("Linea vacia no esperada")

    op = parts[0].lower()

    if op in R_FUNCT or op == "nop":
        return encode_r(parts)

    if op in I_OPCODE:
        return encode_i(parts, labels, pc)

    if op in J_OPCODE:
        return encode_j(parts, labels)

    raise ValueError(f"Instruccion no soportada: {op}")


def write_default_asm(filename):
    with open(filename, "w", encoding="utf-8") as f:
        f.write(DEFAULT_ASM)


def write_mem_file(output_file, machine_code, total_bytes=256):
    line_count = 0

    with open(output_file, "w", encoding="utf-8") as f:
        for code in machine_code:
            bits = f"{code:032b}"

            f.write(bits[0:8] + "\n")
            f.write(bits[8:16] + "\n")
            f.write(bits[16:24] + "\n")
            f.write(bits[24:32] + "\n")

            line_count += 4

        while line_count < total_bytes:
            f.write("00000000\n")
            line_count += 1


def assemble(input_file, output_file):
    with open(input_file, "r", encoding="utf-8") as f:
        lines = f.readlines()

    labels, instructions = first_pass(lines)

    machine_code = []

    for pc, instruction in enumerate(instructions):
        code = encode_instruction(instruction, labels, pc)
        machine_code.append(code)

    write_mem_file(output_file, machine_code)

    print("Ensamblado terminado correctamente.")
    print(f"Archivo ASM usado: {input_file}")
    print(f"Archivo MEM generado: {output_file}")
    print(f"Instrucciones generadas: {len(machine_code)}")
    print("Formato generado: binario de 8 bits por linea")
    print("Cada instruccion ocupa 4 lineas")
    print("Archivo rellenado con 00000000 hasta 256 bytes")


def main():
    if len(sys.argv) == 1:
        asm_file = "programa.asm"
        mem_file = "TestF3_MemInst.mem"

        write_default_asm(asm_file)
        assemble(asm_file, mem_file)
        return

    if len(sys.argv) == 2:
        asm_file = sys.argv[1]
        mem_file = "TestF3_MemInst.mem"
        assemble(asm_file, mem_file)
        return

    if len(sys.argv) >= 3:
        asm_file = sys.argv[1]
        mem_file = sys.argv[2]
        assemble(asm_file, mem_file)
        return


if __name__ == "__main__":
    main()