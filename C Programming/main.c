// HW 1
#include <stdio.h>
#include <math.h>
#include <string.h>

// For PI Usage
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// Part 1
float computeArea(int *v1, int *v2, int shape) {
    
    float area;

            // Triangle Area
            if (shape == 1) {
                area = (*v1) * (*v2) / 2.0;
            }

            // Rectangle Area 
            else if (shape == 2) {
                area = (*v1) * (*v2);
            }
            
            // Circle Area
            else if (shape == 3) {
                float radius = (*v1 / 2.0);
                area = M_PI * radius * radius;
            }
            

    return area;
}

// Part 2
int numTimesAppears(char *mystring, char ch) {
    int count = 0;
    int i;
    
        for(i= 0; i < strlen(mystring); ++i) { 
            if (mystring[i] == ch) { 
               ++count;
        }
    }

    return count;
}


int main() {
    
    // Integer Variables
    int base = 25;
    int height = 25;
    int width = 10;
    int diameter = 5;

    // Part 1
    printf("The area of a triangle is %f\n", computeArea(&base, &height, 1));

    printf("The area of a rectangle is %f\n", computeArea(&height, &width, 2));
    
    printf("The area of a circle is %f\n", computeArea(&diameter, NULL, 3));

    
    // Part 2
    char mystring[100] = "Brandon Nguyen";
    char ch = 'n';
    int count;
    
    count = numTimesAppears(mystring, ch);
    printf("\nNumber of times %c appears in string is %d", ch, count);

    return 0;
}

// HW 2

#include <stdio.h>


int main() {
int number, shiftleft3;

    printf("Brandon Nguyen, 827813045\n");


    printf("Enter number from keyboard: ");
    scanf("%d", &number);


    // Left Shift Operator
    shiftleft3 = number << 3;
    printf("\nLeft Shift By 3: %d", shiftleft3);


    return 0;
}

// HW 3

#include <stdio.h>

int* arrayAddress( int row, int col, int ncolumns, int array[][ncolumns]);

int main() {
int row, col;
int array[3][5] = {{1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}, {11, 12, 13, 14, 15}};

    
    
printf("Enter row number (0-2): ");
    scanf("%d", &row);
    
printf("Enter column number (0-4): ");
    scanf("%d", &col);


int* address = arrayAddress(row, col, 5, array);
    

printf("Address: %p\n", (void*)address);
printf("Value: %d\n", *address);


    return 0;

}

    int* arrayAddress( int row, int col, int ncolumns, int array[][ncolumns]) {

        return &array[row][col];
}

//