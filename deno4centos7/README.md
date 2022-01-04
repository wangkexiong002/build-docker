# Docker image: wangkexiong/deno4centos7

![License](https://img.shields.io/github/license/wangkexiong002/build-docker)
![1.5.4](https://img.shields.io/docker/v/wangkexiong/deno4centos7/1.5.4?style=social)
![1.6.3](https://img.shields.io/docker/v/wangkexiong/deno4centos7/1.6.3?style=social)
![1.16.4](https://img.shields.io/docker/v/wangkexiong/deno4centos7/1.16.4?style=social)

## WHY?
[Deno project][] on github provides binary for linux, but it depends on GLIBC_2.18.

And in REL7/CentOS7, the glibc libraries (libc/libm/libpthread/etc...) are based on the glibc2.17 release.

I run this project to make the docker image with new build of deno binary on REL7/CentOS7.

```bash
$ docker run --rm wangkexiong/deno4centos7:1.5.4 cat /usr/local/bin/deno > deno
$ chmod +x deno
$ ./deno -V
deno 1.5.4
```


[Deno project]: https://github.com/denoland/deno
