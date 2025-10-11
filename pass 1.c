#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct {
    char mnemonic[20];
    int code;
} OPTentry;

int search_optab(OPTentry optab[40], int n, char *op) {
    for (int i = 0; i < n; i++) {
        if (strcmp(optab[i].mnemonic, op) == 0)
            return 1; // Found in OPTAB
    }
    return 0;
}

int main() {
    FILE *fp1, *fp2, *fp3;
    char label[30], opcode[30], operand[30];
    OPTentry optab[50];
    int start = 0, locctr = 0, optab_size = 0;

    // Read OPTAB
    fp1 = fopen("optab.dat", "r");
    if (fp1 == NULL) {
        printf("File cannot be opened (optab.dat)\n");
        return 1;
    }

    while (fscanf(fp1, "%s %x", optab[optab_size].mnemonic, &optab[optab_size].code) != EOF) {
        optab_size++;
    }
    fclose(fp1);

    // Open source file
    fp1 = fopen("input.dat", "r");
    if (fp1 == NULL) {
        printf("File cannot be opened (input.dat)\n");
        return 1;
    }

    fp2 = fopen("intermediate.dat", "w");
    fp3 = fopen("symtab.dat", "w");

    fscanf(fp1, "%s %s %s", label, opcode, operand);

    // START directive
    if (strcmp(opcode, "START") == 0) {
        start = strtol(operand, NULL, 16);
        locctr = start;
        fprintf(fp2, "%X\t%s\t%s\t%s\n", locctr, label, opcode, operand);
        fscanf(fp1, "%s %s %s", label, opcode, operand);
    }

    // Process lines until END
    while (strcmp(opcode, "END") != 0) {
        fprintf(fp2, "%X\t%s\t%s\t%s\n", locctr, label, opcode, operand);

        // Add to SYMTAB if label exists
        if (strlen(label) > 0 && strcmp(label, "-") != 0) {
            fprintf(fp3, "%s\t%X\n", label, locctr);
        }

        // Update LOCCTR based on instruction type
        if (search_optab(optab, optab_size, opcode))
            locctr += 3;
        else if (strcmp(opcode, "WORD") == 0)
            locctr += 3;
        else if (strcmp(opcode, "RESW") == 0)
            locctr += 3 * atoi(operand);
        else if (strcmp(opcode, "RESB") == 0)
            locctr += atoi(operand);
        else if (strcmp(opcode, "BYTE") == 0) {
            if (operand[0] == 'C')
                locctr += strlen(operand) - 3; // subtract C' and '
            else if (operand[0] == 'X')
                locctr += (strlen(operand) - 3 + 1) / 2; // hex chars / 2
        }

        fscanf(fp1, "%s %s %s", label, opcode, operand);
    }

    fprintf(fp2, "%X\t%s\t%s\t%s\n", locctr, label, opcode, operand);
    printf("Program length = %X\n", (locctr - start));

    fclose(fp1);
    fclose(fp2);
    fclose(fp3);

    return 0;
}
