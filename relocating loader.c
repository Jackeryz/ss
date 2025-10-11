#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char add[20], length[20], input[20], bitmask[50], relocbit;
    int start, len, i, address, opcode, addr, actualadd;
    FILE *fp1, *fp2;

    printf("Enter the actual starting address: ");
    scanf("%d", &start);

    fp1 = fopen("relinput.dat", "r");
    if (fp1 == NULL) {
        printf("Could not open input file.\n");
        return 1;
    }

    fp2 = fopen("reloutput.dat", "w");
    if (fp2 == NULL) {
        printf("Could not open output file.\n");
        fclose(fp1);
        return 1;
    }

    fscanf(fp1, "%s", input);

    // Process all records
    while (strcmp(input, "E") != 0) {
        if (strcmp(input, "H") == 0) {
            fscanf(fp1, "%s%s%s", add, length, input); // skip header
        } 
        else if (strcmp(input, "T") == 0) {
            fscanf(fp1, "%d%s", &address, bitmask);
            address += start;
            len = strlen(bitmask);

            for (i = 0; i < len; i++) {
                fscanf(fp1, "%d%d", &opcode, &addr);
                relocbit = bitmask[i];

                if (relocbit == '0')
                    actualadd = addr;
                else
                    actualadd = addr + start;

                fprintf(fp2, "%d\t%d\t%d\n", address, opcode, actualadd);
                printf("Address: %d\tOpcode: %d\tActual: %d\n", address, opcode, actualadd);

                // Print M record if relocatable
                if (relocbit == '1') {
                    fprintf(fp2, "M^%06X^05^+PROG\n", address);
                    printf("Modification Record -> M^%06X^05^+PROG\n", address);
                }

                address += 3;
            }
            fscanf(fp1, "%s", input);
        } 
        else {
            fscanf(fp1, "%s", input); // skip unknown tokens
        }
    }

    fclose(fp1);
    fclose(fp2);
    printf("\nRelocation + M records generated in reloutput.dat\n");
    return 0;
}
