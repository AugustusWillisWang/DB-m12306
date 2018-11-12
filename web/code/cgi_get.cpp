#include <iostream>
#include <vector>  
#include <string>  
#include <stdio.h>  
#include <stdlib.h> 

#include <cgicc/CgiDefs.h> 
#include <cgicc/Cgicc.h> 
#include <cgicc/HTTPHTMLHeader.h> 
#include <cgicc/HTMLClasses.h>  

using namespace std;
using namespace cgicc;

int main ()
{
   Cgicc formData;
   
   cout << "Content-type:text/html\n\n";
   cout << "<html>\n";
   cout << "<head>\n";
   cout << "<title>Using GET and POST Methods</title>\n";
   cout << "</head>\n";
   cout << "<body>\n";


   form_iterator fvalue1 = formData.getElement("value1");
   if( !fvalue1->isEmpty() && fvalue1 != (*formData).end()) {
      cout << "Value1: " << **fvalue1 << endl;
   }
   else
      cout << "No text entered for value1" << endl;

   cout << p();

   form_iterator fvalue2 = formData.getElement("value2");
   if( !fvalue2->isEmpty() && fvalue2 != (*formData).end()) {
      // Note this is just a different way to access the string class.
      // See the YoLinux GNU string class tutorial.
      cout << "Value2: " << (**fvalue2).c_str() << endl;
   }

   cout << p();

   form_iterator fvalue3 = formData.getElement("value3");
   if( !fvalue3->isEmpty() && fvalue3 != (*formData).end()) {
      cout << "Value3: " << **fvalue3 << endl;
   }

   cout << p();

   cout << "<br/>\n";

   cout << "</body>\n";
   cout << "</html>\n";
   
   return 0;
}
