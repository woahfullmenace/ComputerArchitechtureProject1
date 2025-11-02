#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>
#include <errno.h>

#ifdef _WIN32
#include <windows.h>
#include <direct.h>
#include <process.h>
static double now_seconds(void) {
    LARGE_INTEGER freq, counter;
    QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&counter);
    return (double)counter.QuadPart / (double)freq.QuadPart;
}
#else
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <pthread.h>
static double now_seconds(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec + (double)ts.tv_nsec / 1e9;
}
#endif

#define N 1000

static int ensure_parent_dir(const char *path) {
    if (!path || !*path) return 0;
    char buf[1024];
    size_t len = strlen(path);
    if (len >= sizeof(buf)) { fprintf(stderr, "Error: path too long: %s\n", path); return -1; }
    memcpy(buf, path, len + 1);
    char *last_sep = NULL; for (char *p = buf; *p; ++p) if (*p=='/'||*p=='\\') last_sep=p;
    if (!last_sep) return 0;
    char *p = buf; while (*p) { if (*p=='/'||*p=='\\') { char s=*p; *p='\0'; if (buf[0] != '\0') {
#ifdef _WIN32
        if (_mkdir(buf) != 0 && errno != EEXIST)
#else
        if (mkdir(buf, 0755) != 0 && errno != EEXIST)
#endif
        { if (errno != EEXIST) { fprintf(stderr, "mkdir '%s' failed (errno=%d)\n", buf, errno); return -1; } } } *p=s; } ++p; }
    char s=*last_sep; *last_sep='\0';
#ifdef _WIN32
    if (_mkdir(buf) != 0 && errno != EEXIST)
#else
    if (mkdir(buf, 0755) != 0 && errno != EEXIST)
#endif
    { if (errno != EEXIST) { fprintf(stderr, "mkdir '%s' failed (errno=%d)\n", buf, errno); *last_sep=s; return -1; } }
    *last_sep=s; return 0;
}

static int read_matrix(const char *path, double *mat, size_t n) {
    FILE *f = fopen(path, "rb"); if (!f) { fprintf(stderr, "Error: cannot open '%s' for reading.\n", path); return -1; }
    size_t need=n*n, got=fread(mat, sizeof(double), need, f); if (got!=need) { fprintf(stderr,"Error: expected %zu doubles, read %zu from '%s'.\n",(size_t)need,(size_t)got,path); fclose(f); return -1; }
    fclose(f); return 0;
}
static int write_matrix(const char *path, const double *mat, size_t n) {
    FILE *f = fopen(path, "wb"); if (!f) { fprintf(stderr,"Error: cannot open '%s' for writing.\n",path); return -1; }
    size_t need=n*n, wrote=fwrite(mat, sizeof(double), need, f); if (wrote!=need) { fprintf(stderr,"Error: expected to write %zu doubles, wrote %zu to '%s'.\n",(size_t)need,(size_t)wrote,path); fclose(f); return -1; }
    fclose(f); return 0;
}

typedef struct { const double *a; const double *b; double *c; size_t n; size_t r0, r1; } thread_args_t;

static void matmul_rows(const double *a, const double *b, double *c, size_t n, size_t r0, size_t r1) {
    for (size_t i=r0;i<r1;++i){ const size_t io=i*n; for(size_t j=0;j<n;++j) c[io+j]=0.0; for(size_t k=0;k<n;++k){ const double aik=a[io+k]; const size_t ko=k*n; for(size_t j=0;j<n;++j){ c[io+j]+=aik*b[ko+j]; } } }
}

#ifdef _WIN32
static unsigned __stdcall worker(void *arg){ thread_args_t *t=(thread_args_t*)arg; matmul_rows(t->a,t->b,t->c,t->n,t->r0,t->r1); return 0; }
#else
static void *worker(void *arg){ thread_args_t *t=(thread_args_t*)arg; matmul_rows(t->a,t->b,t->c,t->n,t->r0,t->r1); return NULL; }
#endif

int main(int argc, char **argv){
    const char *in1 = (argc>1)?argv[1]:"data/data1/data1";
    const char *in2 = (argc>2)?argv[2]:"data/data2/data2";
    const char *out = (argc>3)?argv[3]:"build/output/data3_part5";
    double *mat1=(double*)malloc(sizeof(double)*N*N), *mat2=(double*)malloc(sizeof(double)*N*N), *mat3=(double*)malloc(sizeof(double)*N*N);
    if(!mat1||!mat2||!mat3){ fprintf(stderr,"Error: alloc failed.\n"); free(mat1); free(mat2); free(mat3); return 1; }
    if(read_matrix(in1,mat1,N)!=0){ free(mat1); free(mat2); free(mat3); return 1; }
    if(read_matrix(in2,mat2,N)!=0){ free(mat1); free(mat2); free(mat3); return 1; }

    thread_args_t args[4]; size_t q=N/4; // 250
    args[0]=(thread_args_t){mat1,mat2,mat3,N,0,q};
    args[1]=(thread_args_t){mat1,mat2,mat3,N,q,2*q};
    args[2]=(thread_args_t){mat1,mat2,mat3,N,2*q,3*q};
    args[3]=(thread_args_t){mat1,mat2,mat3,N,3*q,N};

    double t0=now_seconds();
#ifdef _WIN32
    uintptr_t h[4]; for(int i=0;i<4;++i){ h[i]=_beginthreadex(NULL,0,worker,&args[i],0,NULL); if(!h[i]){ fprintf(stderr,"thread create failed\n"); return 1; } }
    WaitForMultipleObjects(4,(HANDLE*)h,TRUE,INFINITE); for(int i=0;i<4;++i) CloseHandle((HANDLE)h[i]);
#else
    pthread_t th[4]; for(int i=0;i<4;++i) pthread_create(&th[i],NULL,worker,&args[i]); for(int i=0;i<4;++i) pthread_join(th[i],NULL);
#endif
    double t1=now_seconds(); double elapsed=t1-t0;

    if(ensure_parent_dir(out)!=0){ free(mat1); free(mat2); free(mat3); return 1; }
    if(write_matrix(out,mat3,N)!=0){ free(mat1); free(mat2); free(mat3); return 1; }
    printf("%lf %lf %lf %lf\n", mat3[6*N+0], mat3[5*N+3], mat3[5*N+4], mat3[901*N+7]);
    fprintf(stderr,"Multiply time (Part 5, 4 threads): %.6f seconds\n", elapsed);
    free(mat1); free(mat2); free(mat3); return 0;
}

