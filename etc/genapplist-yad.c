/* =============================================================== *
 *      Pi-Apps app list preloader for YAD GUI app list style.     *
 *               Written by Itai-Nelken 09/09/2021                 *
 * --------------------------------------------------------------- *
 *      gcc genapplist-yad.c -o prel -Wall -Wextra -Wpedantic      *
 * =============================================================== */


#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <assert.h>

/******
 * Check if a file exists
 * 
 * @param path The path to the file to check.
 * 
 * @return 0: exists, 1: doesn't exist
 ******/
int fileExists(const char *path) {
	FILE *file=fopen(path, "rb");
	if (!file) {
		return 1;
	}
	fclose(file);
    return 0;
}

/******
 * Fill a string with nul (\0) characters
 * 
 * @param str The string to fill.
 ******/
void str_zero(char *str) {
	char *s=str;
	while(*s++) {
		*s='\0';
	}
}

/******
 * Get a single line from a file.
 * 
 * @param filename The path to the file to get the line from.
 * @param out The char array to put the line in.
 * @param size The size of 'out'.
 ******/
void getLine(const char *filename, char *out, size_t size) {
	FILE *f=fopen(filename, "r");
	if(!f) {
		perror("getLine(): fopen()");
	} else {
		fgets(out, size, f);
		fclose(f);
	}
}

/******
 * get the status of a app in pi-apps
 * 
 * @param directory The path to the pi-apps folder (e.g /home/pi/pi-apps)
 * @param app The app to get it's status.
 * @param status The char array to put the status in.
 * @param size The size of 'status'.
 ******/
void get_app_status(char *directory, const char *app, char *status, size_t size) {
	char path[250]={0}, st[4096]={0};
	snprintf(path, 250, "%s/data/status/%s", directory, app);
	if (!fileExists(path)) { //if 'path' exists
		getLine(path, st, 4096);
		st[strlen(st)-1]='\0';
		assert(strlen(st)<=size);
		snprintf(status, size, "%s", st);
	} else {
    snprintf(status, size, "uninstalled");
	}
}

/******
 * get the status of a app in pi-apps but if it doesn't have a status file but it exists, use "none"
 * 
 * @param directory The path to the pi-apps folder (e.g /home/pi/pi-apps)
 * @param app The app to get it's status.
 * @param status The char array to put the status in.
 * @param size The size of 'status'.
 ******/
void get_app_status_with_none(char *directory, const char *app, char *status, size_t size) {
	char path[250]={0}, st[4096]={0};
	snprintf(path, 250, "%s/data/status/%s", directory, app);
	if (!fileExists(path)) { //if 'path' exists
		getLine(path, st, 4096);
		st[strlen(st)-1]='\0';
		assert(strlen(st)<=size);
		snprintf(status, size, "%s", st);
	} else {
			snprintf(status, size, "none");
	}
}

/******
 * get the path to the status icon for a app based on the it's status.
 * 
 * @param directory The path to the pi-apps folder (e.g /home/pi/pi-apps)
 * @param app The app to get it's status icon.
 * @param status The char array to put the status icon in.
 * @param size The size of 'icon'.
 ******/
void get_status_icon(char *directory, const char *app, char *icon, size_t size) {
	char path[300]={0}, status[30]={0};
	get_app_status_with_none(directory, app, status, 30);
	snprintf(path, 300, "%s/icons/%s.png", directory, status);
	if(!fileExists(path)) {
		assert(strlen(path)<=size);
		strncpy(icon, path, size);
	} else {
		//fprintf(stderr, "ERROR: get_icon_name(): icon \"%s\" doesn't exist!\n", path);
		assert(strlen(directory)+15<=size);
		snprintf(icon, strlen(directory)+15, "%s/icons/none.png", directory);
	}
}

/******
 * get the path to a apps icon.
 * 
 * @param directory The path to the pi-apps folder (e.g /home/pi/pi-apps)
 * @param app The app to get it's icon path.
 * @param icon The char array to put the status in.
 * @param size The size of 'icon'.
 ******/
void get_app_icon(char *directory, const char *app, char *icon, size_t size) {
	char path[4096]={0};
	snprintf(path, 4096, "%s/apps/%s/icon-24.png", directory, app);
	if(!fileExists(path)) {
		assert(strlen(path)<=size);
		strncpy(icon, path, size);
	} else {
		fprintf(stderr, "ERROR: get_app_icon(): app \"%s\" doesn't have a icon-24!\n", app);
	}
}

/******
 * get the status and first line of the description of an app in the following format: '(STATUS) DESCRIPTION'
 * 
 * @param directory The path to the pi-apps folder (e.g /home/pi/pi-apps)
 * @param app The app
 * @param out The char array to put the output in.
 * @param size The size of 'out'.
 ******/
void get_app_status_and_desc(char *directory, const char *app, char *out, size_t out_size) {
	char path[4096]={0}, buffer[out_size], status[30]={0};
	str_zero(buffer);
	snprintf(path, 4096, "%s/apps/%s/description", directory, app);
	if(!fileExists(path)) {
		getLine(path, buffer, out_size);
		buffer[strlen(buffer)-1]='\0'; // remove newline from end
		get_app_status(directory, app, status, 30);
		snprintf(out, out_size+33, "(%s) %s", status, buffer);
	} else {
		fprintf(stderr, "ERROR: get_app_status_and_desc(): app \"%s\" doesn't have a description!\n", app);
	}
}

/******
 * Collect and print to stdout all the data for a app.
 * 
 * @param app the app to use
 * @param directory the path to the pi-apps folder (e.g /home/pi/pi-apps)
 ******/
void print_all(const char *app, char *directory) {
	char st_icon[300]={0}, app_icon[4096]={0}, desc[4096]={0};
	get_status_icon(directory, app, st_icon, 300);
	get_app_icon(directory, app, app_icon, 4096);
	get_app_status_and_desc(directory, app, desc, 4096);
	printf("%s\n%s\n%s\n%s\n%s\n", st_icon, app_icon, app, app, desc);
}

int main(void) {
	// get pointers to the DIRECTORY and APPS environment variables
	// They should be set when running this program
	char *dir=getenv("DIRECTORY");
	char *apps=getenv("APPS");

	// If they don't existt, print an error and exit.
	if(!apps) {
		fprintf(stderr, "ERROR: \"APPS\" environment variable isn't set!\n");
		return 1;
	}
	if(!dir) {
		fprintf(stderr, "ERROR: \"DIRECTORY\" environment variable isn't set!\n");
		return 1;
	}

	// remove the trailing '/' from DIRECTORY if it exists
	if(dir[strlen(dir)-1]=='/') {
		dir[strlen(dir)-1]='\0';
	}

	// separator for strok()
    const char *separator="\n";
    char *parsed;
    
    // get the first "token"
    parsed=strtok(apps, separator);
    while(parsed!=NULL) { // print all the data for every app in APPS
		print_all(parsed, dir);

        parsed=strtok(NULL, separator);
    }

	return 0;
}

/*** REQUIRED OUTPUT ***
 * 1) status icon
 * 2) app icon
 * 3) app name
 * 4) app folder name (in ~/pi-apps/apps)
 * 5) status and short description
***********************/

/* LOOP OVER EVERY APP IN $HOME/PI-APPS/APPS *
char *home=getHomePath();
	char path[strlen(home)+20];
	str_zero(path);
	snprintf(path, strlen(home)+20, "%s/pi-apps/apps", home);
	DIR *dir;
	struct dirent *d;
	dir=opendir(path);
	if(!dir) {
		fprintf(stderr, "ERROR: failed to open directory \"%s\"!\n", path);
	} else {
		while((d=readdir(dir))!=NULL) {
			if(strcmp(d->d_name, ".")&&strcmp(d->d_name, "..")&&strcmp(d->d_name, "template")) {
				print_all(d->d_name);
			}
		}
		closedir(dir);
	}
**************************************************/

/*********************************************
void remove_all_chars(char* str, char c) {
	char *pr = str, *pw = str;
	while (*pr) {
	    *pw = *pr++;
	    pw += (*pw != c);
	}
	*pw = '\0';
}
***********************************************/
