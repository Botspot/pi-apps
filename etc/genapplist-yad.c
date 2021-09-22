/* ========================================================= *
 *      Pi-Apps app preloader for YAD GUI app list style.    *
 *        Written by Itai-Nelken 09/09/2021 (MM/DD/YY).      *
 * --------------------------------------------------------- *
 *  gcc pi-apps_app-prel.c -o prel -Wall -Wextra -Wpedantic  *
 * ========================================================= */


#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <assert.h>

// check if a file exists
int fileExists(const char *path) {
	FILE *file=fopen(path, "rb");
	if (!file) {
		return 1;
	}
	fclose(file);
    return 0;
}

// fill a string with nul characters ('\0')
void str_zero(char *str) {
	char *s=str;
	while(*s++) {
		*s='\0';
	}
}

// get a single line from a file
void getLine(const char *filename, char *out, size_t size) {
	FILE *f=fopen(filename, "r");
	if(!f) {
		perror("getLine(): fopen()");
	} else {
		fgets(out, size, f);
		fclose(f);
	}
}

// get the status of a app in pi-apps
void get_app_status(const char *app, char *status, size_t size) {
	char path[250]={0}, st[4096]={0}, *directory=getenv("DIRECTORY");
	snprintf(path, 250, "%s/data/status/%s", directory, app);
	if (!fileExists(path)) { //if 'path' exists
		getLine(path, st, 4096);
		st[strlen(st)-1]='\0';
		assert(strlen(st)<=size);
		snprintf(status, size, "%s", st);
	} else {
		snprintf(path, 250, "%s/apps/%s/uninstall", directory, app);
		if(!fileExists(path)) {
			assert(strlen("uninstalled")<=size);
			snprintf(status, size, "uninstalled");
		} else {
			fprintf(stderr, "ERROR: get_app_status(): No such app: \"%s\"!\n", app);
		}
	}
}

// get the status of a app in pi-apps but print 'none' if the app has no status file
// but it exists (it has a uninstall script)
void get_app_status_with_none(const char *app, char *status, size_t size) {
	char path[250]={0}, st[4096]={0}, *directory=getenv("DIRECTORY");
	snprintf(path, 250, "%s/data/status/%s", directory, app);
	if (!fileExists(path)) { //if 'path' exists
		getLine(path, st, 4096);
		st[strlen(st)-1]='\0';
		assert(strlen(st)<=size);
		snprintf(status, size, "%s", st);
	} else {
		snprintf(path, 250, "%s/apps/%s/uninstall", directory, app);
		if(!fileExists(path)) {
			assert(strlen("none")<=size);
			snprintf(status, size, "none");
		} else {
			fprintf(stderr, "ERROR: get_app_status(): No such app: \"%s\"!\n", app);
		}
	}
}

// get the path to the status icon for a app based on the it's status
void get_status_icon(const char *app, char *icon, size_t size) {
	char path[300]={0}, *directory=getenv("DIRECTORY"), status[30]={0};
	get_app_status_with_none(app, status, 30);
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

// get the path to a app's icon
void get_app_icon(const char *app, char *icon, size_t size) {
	char path[4096]={0}, *directory=getenv("DIRECTORY");
	snprintf(path, 4096, "%s/apps/%s/icon-24.png", directory, app);
	if(!fileExists(path)) {
		assert(strlen(path)<=size);
		strncpy(icon, path, size);
	} else {
		fprintf(stderr, "ERROR: get_app_icon(): app \"%s\" doesn't have a icon-24!\n", app);
	}
}

// get the status and first line of the description of an app in a format like this:
// "(<STATUS>) <SHORT DESCRIPTION>" 
void get_app_status_and_desc(const char *app, char *out, size_t out_size) {
	char path[4096]={0}, buffer[out_size], status[30]={0}, *directory=getenv("DIRECTORY");
	str_zero(buffer);
	snprintf(path, 4096, "%s/apps/%s/description", directory, app);
	if(!fileExists(path)) {
		getLine(path, buffer, out_size);
		buffer[strlen(buffer)-1]='\0'; // remove newline from end
		get_app_status(app, status, 30);
		snprintf(out, out_size+33, "(%s) %s", status, buffer);
	} else {
		fprintf(stderr, "ERROR: get_app_status_and_desc(): app \"%s\" doesn't have a description!\n", app);
	}
}

// collect and print all the data
void print_all(const char *app) {
	char st_icon[300]={0}, app_icon[4096]={0}, desc[4096]={0};
	get_status_icon(app, st_icon, 300);
	get_app_icon(app, app_icon, 4096);
	get_app_status_and_desc(app, desc, 4096);
	printf("%s\n%s\n%s\n%s\n%s\n", st_icon, app_icon, app, app, desc);
}

int main(void) {
	if(!getenv("APPS")) {
		fprintf(stderr, "ERROR: \"APPS\" environment variable isn't set!\n");
		return 1;
	}
	if(!getenv("DIRECTORY")) {
		fprintf(stderr, "ERROR: \"DIRECTORY\" environment variable isn't set!\n");
		return 1;
	}

    char *separator="\n";
    char *parsed;
    
    parsed=strtok(getenv("APPS"), separator);
    while(parsed!=NULL) {
		print_all(parsed);

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
