#include <time.h>

// Sleep for seconds + nanoseconds
int nanodelay(int sec, int nsec) {
	struct timespec t;
	t.tv_sec = sec;
	t.tv_nsec = nsec;

	return nanosleep( &t, NULL );
}
