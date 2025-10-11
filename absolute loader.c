#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *fp;
    char label;
    char name[10], objcode[10];
    int startAddr, length, address, i;

    fp = fopen("absinput.dat", "r");

    if (fp == NULL) {
        printf("Error: Cannot open input file.\n");
        return 1;
    }

    printf("Opened 'absinput.dat' successfully.\n\n");

    while (fscanf(fp, " %c", &label) != EOF) {
        if (label == 'H') {
            fscanf(fp, "%s %x %x", name, &startAddr, &length);
            printf("Header -> Program: %s, Start: %X, Length: %X\n", name, startAddr, length);
        }

        else if (label == 'T') {
            fscanf(fp, "%x %x", &address, &length);
            printf("\nText -> Start: %X, Length: %X\n", address, length);

            char line[100];
            fgets(line, sizeof(line), fp); // Read rest of the line after T record

            char *token = strtok(line, " \n");
            while (token != NULL) {
                printf("Address: %X   Object Code: %s\n", address, token);
                address += 3;  // increment address assuming 3 bytes per instruction
                token = strtok(NULL, " \n");
            }
        }

        else if (label == 'E') {
            printf("\nProgram loaded successfully!\n");
            break;
        }
    }

    fclose(fp);
    return 0;
}
