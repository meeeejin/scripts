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
    ofstream writeFile;
	int free = 0;
    unsigned long long int count[10] = {0,};
    string str;
    string intro = "Percentage\tCount\n";

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
        // Calculate the corresponding range of each page
        while (getline(readFile, str)) {
            istringstream is(str);
            is >> free;

			int idx = (free * 100 / PAGE_SIZE) % 10;
			count[idx]++;
		}

        // Write the result
		int i;
		unsigned long long int sum = 0;

		for (i = 0; i < 10; i++)	sum += count[i];
		for (i = 0; i < 9; i++) {
			stringstream ss;
			ss << i * 10 << " - " << (i + 1) * 10 << "\t\t" << count[i]
			   << "\t(" << fixed << setprecision(1) << ((double)count[i] / (double) sum) * 100  << "%)"
			   << endl;

			string result = ss.str();
			writeFile.write(result.c_str(), result.size());
		}
	
		// For the pretty format
		stringstream ss, outtro;
		ss << i * 10 << " - " << (i + 1) * 10 << "\t" << count[i]
		   << "\t(" << count[i] * 100 / sum  << "%)"
		   << endl;

		string result = ss.str();
		writeFile.write(result.c_str(), result.size());
       
	   	// Write the total count
		outtro << "Total\t\t" << sum << "\t(100%)" << endl;
		result = outtro.str();
		writeFile.write(result.c_str(), result.size());

		cout << "\nThe result is saved to " << argv[2] << endl;
    }

    // Close the opened files
    readFile.close();
    writeFile.close();

    return 0;
}
