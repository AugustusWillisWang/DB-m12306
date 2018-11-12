/**
 * compile: gcc simple.c -o simple.cgi
 */

#include "stdio.h"
#include "stdlib.h"
#include <string.h>

int main()
{
     char *data;
     data = getenv("QUERY_STRING");
     printf("Content-type:text/html\n\n");
     puts(data);
     printf("<br />above is cgi received parameters");

     return 0;
}
