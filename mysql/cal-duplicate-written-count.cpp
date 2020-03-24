#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib>
#include <iomanip>
using namespace std;

int main(int argc, char **argv) {
    if (argc != 3) {
        cerr << argv[0] << ": error: No argument specified" << endl;
        return 1;
    }

    ifstream readFile;
    ofstream writeFile;
    int curPage, prevPage = 0;
    unsigned long long int curLsn, totalLsn = 0, count = 0;
    string str;
    string intro = "Page number \tCount\tLSN Gap\n";

    // Open the file for read
    readFile.open(argv[1]);

    if (!readFile) {
        cerr << argv[0] << ": error: No such file" << endl;
        return 1;
    }

    // Open a file for write
    writeFile.open(argv[2]);
    writeFile.write(intro.c_str(), intro.size());
    
    cout << "\nParse " << argv[1] << endl;
    
    if (readFile.is_open()) {
        // Calculate the duplicate written count of each page
        while (getline(readFile, str)) {
            istringstream is(str);
            is >> curPage >> curLsn;

            if (curPage == prevPage) {
                totalLsn += curLsn;
            } else {
                if (count != 0) {
                    // Write the result
                    stringstream ss;
                    ss << prevPage << " \t\t" << count << "\t"
                       << totalLsn / count << endl;
                    
                    string result = ss.str();
                    writeFile.write(result.c_str(), result.size());

                    // Reset the count value
                    count = 0;    
                }

                prevPage = curPage;
                totalLsn = curLsn;
            }
            count++;
        }

        // Write the result
        stringstream ss;
        ss << prevPage << " \t\t" << count << "\t"
            << totalLsn / count << endl;

        string result = ss.str();
        writeFile.write(result.c_str(), result.size());

        cout << "\nThe result is saved to " << argv[2] << endl;
    }

    // Close the opened files
    readFile.close();
    writeFile.close();

    return 0;
}
