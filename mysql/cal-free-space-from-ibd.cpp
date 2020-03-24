#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib>
using namespace std;

int main(int argc, char **argv) {
    if (argc != 3) {
        cerr << argv[0] << ": error: No argument specified" << endl;
        return 1;
    }

    ifstream readFile;
    ofstream writeFile;
    int min = 4096, max = 0, sum = 0, count = 0;
    int page, index, level, data, free, records;
    string str;

    // Open the file for read
    readFile.open(argv[1]);

    if (!readFile) {
        cerr << argv[0] << ": error: No such file" << endl;
        return 1;
    }

    // Calculate the amount of data and free space of each page in the given input file (.ibd)
    cout << "\nParse " << argv[1] << endl;
   
    stringstream cmd;
    cmd << "innodb_space -f " << argv[1] << " space-index-pages-summary > " << "space-summary.txt";
    system(cmd.str().c_str());

    cout << "\nThe parsed file is saved to space-summary.txt" << endl;
    cout << "\nParse space-summary.txt" << endl;

    if (readFile.is_open()) {
        // Skip the first line
        getline(readFile, str);
        
        // Calculate the average free space of total pages in the given .ibd file
        while (getline(readFile, str)) {

            istringstream is(str);
            is >> page >> index >> level >> data >> free >> records;

            if (min > free) min = free;
            if (max < free) max = free;
        
            sum += free;
            count++;
        }

        // Print and save the result
        stringstream ss;
        ss << "\n# Parsing Result\nTotal number of pages = " << count
           << "\nTotal free space = " << sum
           << "\nAverage free space per page = " << sum / count
           << "\nMin free space = " << min
           << "\nMax free space = " << max << endl;

        string result = ss.str();
        cout << result << endl;

        // Open a file for write
        writeFile.open(argv[2]);
        writeFile.write(result.c_str(), result.size());
        cout << "The result is saved to " << argv[2] << endl;
    }

    // Close the opened files
    readFile.close();
    writeFile.close();

    return 0;
}
