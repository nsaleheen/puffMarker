# SQLite-Matlab
SQLite-Matlab is a toolbox that allows users to read and write [SQLite](http://en.wikipedia.org/wiki/SQLite) databases from within [Matlab](http://en.wikipedia.org/wiki/MATLAB).

## Usage
1. Download the latest version from the [Downloads tab](https://bitbucket.org/GarrettFoster/sqlite-matlab/downloads)
2. Extract the contents to a new folder
3. Start Matlab and navigate to the new folder
4. In the Matlab command window type ``sqlite('','test.db');``
   * An empty database file called test.db should appear in your folder indicating a working toolbox
* For more information type ``help sqlite`` into the command window
* If you experience any issues file a [bug report](https://bitbucket.org/GarrettFoster/sqlite-matlab/issues/new)

## Installation
1. This is only needed if you want to use the sqlite command outside of the folder you created
2. type ``pathtool`` into the Matlab command window
  * you should see a dialog pop up
3. Click on "add folder"
4. Navigate the the folder you extracted the toolbox to and select it
5. With the folder still higlighted select "move to bottom"
6. Click save if you don't want to do this each time
  * if the main directory isn't writeable, you may have to save to your startup folder

## Useful Links
- [SQLite syntax](http://www.sqlite.org/lang.html)
- [SQL tutorial](http://www.w3schools.com/sql/default.asp)

## Acknowledgements
- SQLite-Matlab was origonally created by Garrett Foster for his [thesis research on design freedom generation](http://repository.lib.ncsu.edu/ir/handle/1840.16/7116)
- Thanks to [Xerial](http://www.xerial.org/) for developing the JDBC driver that this is based on
