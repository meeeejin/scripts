#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cstdlib>
#include <iomanip>
using namespace std;

#define PAGE_SIZE 4096

int main(int argc, char **argv) {
    if (argc != 3) {
        cerr << argv[0] << ": error: No argument specified" << endl;
        return 1;
    }

    ifstream readFile;
	ifstream parsedFile;
    ofstream writeFile;
    unsigned long long int leafMin = PAGE_SIZE, leafMax = 0, leafSum = 0, leafCount = 0;
    unsigned long long int nonleafMin = PAGE_SIZE, nonleafMax = 0, nonleafSum = 0, nonleafCount = 0;
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

	// Open the parsed file
	parsedFile.open("space-summary.txt");

    if (parsedFile.is_open()) {
        // Skip the first line
        getline(parsedFile, str);
        
        // Calculate the average free space of total pages in the given .ibd file
        while (getline(parsedFile, str)) {
            istringstream is(str);
            is >> page >> index >> level >> data >> free >> records;

			if (level == 0) { // Leaf pages
				if (leafMin > free) leafMin = free;
				if (leafMax < free) leafMax = free;
				leafSum += free;
				leafCount++;
			} else { // Non-leaf pages
				if (nonleafMin > free) nonleafMin = free;
				if (nonleafMax < free) nonleafMax = free;
				nonleafSum += free;
				nonleafCount++;
			}
        }

        // Print and save the result
        stringstream ss;
        ss << "\n# Parsing Result\nTotal number of pages = " << leafCount + nonleafCount
           << "\nTotal free space = " << leafSum + nonleafSum
           << "\nAverage free space per page = " << (leafSum + nonleafSum) / (leafCount + nonleafCount)
           << " (" << fixed << setprecision(2) << 100 * (double)(leafSum + nonleafSum) / (double)(leafCount + nonleafCount) / (double) PAGE_SIZE << "%)"
           << "\n\n- Leaf Pages\nTotal number of pages = " << leafCount 
           << "\nTotal free space = " << leafSum
           << "\nAverage free space per page = " << leafSum / leafCount
           << " (" << fixed << setprecision(2) << 100 * (double) leafSum / (double) leafCount / (double) PAGE_SIZE << "%)"
		   << "\nMin free space = " << leafMin
           << "\nMax free space = " << leafMax 
		   << "\n\n- Non-leaf Pages\nTotal number of pages = " << nonleafCount 
           << "\nTotal free space = " << nonleafSum
           << "\nAverage free space per page = " << nonleafSum / nonleafCount
           << " (" << fixed << setprecision(2) << 100 * (double) nonleafSum / (double) nonleafCount / (double) PAGE_SIZE << "%)"
		   << "\nMin free space = " << nonleafMin
           << "\nMax free space = " << nonleafMax 
		   << endl;

        string result = ss.str();
        cout << result << endl;

        // Open a file for write
        writeFile.open(argv[2]);
        writeFile.write(result.c_str(), result.size());
        cout << "The result is saved to " << argv[2] << endl;
    }

    // Close the opened files
    readFile.close();
    parsedFile.close();
    writeFile.close();

    return 0;
}
