#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib>
#include <iomanip>
#include <math.h>
#include <cmath>
using namespace std;

#define ARR_SIZE 2000

int main(int argc, char **argv) {
    if (argc != 3) {
        cerr << argv[0] << ": error: No argument specified" << endl;
        return 1;
    }

    ifstream readFile;
    ofstream writeFile;
    unsigned int curPage, prevPage = 0;
    unsigned long long int curTime, prevTime = 0, count = 0;
    unsigned long long int hour, min, sec, gapTime = 0;
    string str;

    // Open the file for read
    readFile.open(argv[1]);

    if (!readFile) {
        cerr << argv[0] << ": error: No such file" << endl;
        return 1;
    }

    // Open a file for write
    writeFile.open(argv[2]);
    
    cout << "\nParse " << argv[1] << endl;
    
    if (readFile.is_open()) {
        // Calculate the duplicate written count of each page
        getline(readFile, str);
        istringstream is(str);
        is >> hour >> min >> sec >> curPage;
           
        curTime = hour * 60 * 60 + min * 60 + sec; 
        
        prevPage = curPage;
        prevTime = curTime;
        
        count++;

        while (getline(readFile, str)) {
            istringstream is(str);
            is >> hour >> min >> sec >> curPage;

            curTime = hour * 60 * 60 + min * 60 + sec; 
            
            if (curPage == prevPage) {
                gapTime = curTime - prevTime;
                
                // Write the result
                stringstream ss;
                ss << gapTime << endl;
                
                string result = ss.str();
                writeFile.write(result.c_str(), result.size());
            } else {
                if (count == 1) {
                    gapTime = 0;
                    
                    // Write the result
                    stringstream ss;
                    ss << gapTime << endl;

                    string result = ss.str();
                    writeFile.write(result.c_str(), result.size());
                }
                
                count = 0;
            }

            prevPage = curPage;
            prevTime = curTime;

            count++;
        }
        
        if (count == 1) {
            gapTime = 0;

            // Write the result
            stringstream ss;
            ss << gapTime << endl;

            string result = ss.str();
            writeFile.write(result.c_str(), result.size());
        }

        cout << "\nThe result is saved to " << argv[2] << endl;
    }

    // Close the opened files
    readFile.close();
    writeFile.close();

    return 0;
}
