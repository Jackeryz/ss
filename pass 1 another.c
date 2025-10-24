#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Symbol {
    char label[20];
    int address;
} symtab[10];

int symCount = 0;

// Helper to add symbol to table
void addSymbol(char label[], int address) {
    strcpy(symtab[symCount].label, label);
    symtab[symCount].address = address;
    symCount++;
}

// Helper to print symbol table
void printSymTab() {
    printf("\nSymbol Table:\n");
    for (int i = 0; i < symCount; i++) {
        printf("%s\t%X\n", symtab[i].label, symtab[i].address);
    }
}

int main() {
    FILE *fp = fopen("input.txt", "r");
    if (!fp) {
        printf("Cannot open input.txt\n");
        return 1;
    }

    char label[20], opcode[20], operand[20];
    int locctr = 0, startAddr = 0;

    printf("Intermediate Output:\n");

    // Read first line
    fscanf(fp, "%s %s %s", label, opcode, operand);
    if (strcmp(opcode, "START") == 0) {
        startAddr = strtol(operand, NULL, 16);
        locctr = startAddr;
        printf("%X\t%s\t%s\t%s\n", locctr, label, opcode, operand);
    }

    // Process rest of the lines
    while (fscanf(fp, "%s %s %s", label, opcode, operand) != EOF) {
        printf("%X\t%s\t%s\t%s\n", locctr, label, opcode, operand);

        // Add to symbol table if label is not '**' or '*'
        if (strcmp(label, "**") != 0 && strcmp(label, "*") != 0) {
            addSymbol(label, locctr);
        }

        // Handle instructions and directives
        if (strcmp(opcode, "LDA") == 0 || strcmp(opcode, "STA") == 0 ||
            strcmp(opcode, "LDCH") == 0 || strcmp(opcode, "STCH") == 0) {
            locctr += 3; // instruction size
        } else if (strcmp(opcode, "WORD") == 0) {
            locctr += 3;
        } else if (strcmp(opcode, "RESW") == 0) {
            locctr += 3 * atoi(operand);
        } else if (strcmp(opcode, "RESB") == 0) {
            locctr += atoi(operand);
        } else if (strcmp(opcode, "BYTE") == 0) {
            // BYTE C'2' => 1 byte
            if (operand[0] == 'C') {
                locctr += strlen(operand) - 3; // C'2' -> length 3, content length = 1
            }
        } else if (strcmp(opcode, "END") == 0) {
            break;
        }
    }

    fclose(fp);
    printSymTab();

    return 0;
}
