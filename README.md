# Repro Steps

1. `docker build -t base --file base.Dockerfile .`
2. `docker run -it base bash`
3. `esy x Server`

Output:

```
/app/_esy/default/store/i/scamaybe-3a3c5931/bin/Server: error while loading shared libraries: libpcre.so.1: cannot open shared object file: No such file or directory
```
