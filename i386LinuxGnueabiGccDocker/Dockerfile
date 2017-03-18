FROM besn0847/ubuntu32

RUN apt-get update && apt-get install wget make gawk sed libperl4-corelibs-perl g++ lbzip2 -y


ENV PREFIX /home/crossi386
ENV ARCH i686-linux-gnueabi
ENV GLIBCVER 2.13

ENV KERNELVER 3.12.18
ENV KERNELARCH x86
ENV BINUTILSVER 2.28

#ENV GCCVER 4.9.4
#ENV MPFRVER 3.1.2
#ENV GMPVER 6.1.0
#ENV MPCVER 1.0.2
#ENV ISLVER 0.12.2
#ENV CLOOGVER 0.18.1

ENV GCCVER 6.3.0
ENV MPFRVER 3.1.5
ENV GMPVER 6.1.2
ENV MPCVER 1.0.3
ENV ISLVER 0.16.1
ENV CLOOGVER 0.18.1


RUN cd /home && wget http://ftpmirror.gnu.org/binutils/binutils-$BINUTILSVER.tar.gz --no-check-certificate && \
                wget http://ftpmirror.gnu.org/gcc/gcc-$GCCVER/gcc-$GCCVER.tar.gz --no-check-certificate && \
                wget http://www.kernel.org/pub/linux/kernel/v3.x/linux-$KERNELVER.tar.xz --no-check-certificate && \
                wget http://ftpmirror.gnu.org/glibc/glibc-$GLIBCVER.tar.xz --no-check-certificate && \
                wget http://ftp.gnu.org/gnu/libc/glibc-ports-$GLIBCVER.tar.gz --no-check-certificate && \
		wget http://ftpmirror.gnu.org/mpfr/mpfr-$MPFRVER.tar.xz --no-check-certificate && \
                wget http://ftpmirror.gnu.org/gmp/gmp-$GMPVER.tar.xz --no-check-certificate && \
		wget http://ftpmirror.gnu.org/mpc/mpc-$MPCVER.tar.gz --no-check-certificate && \
		wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-$ISLVER.tar.bz2 --no-check-certificate && \
		wget ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-$CLOOGVER.tar.gz --no-check-certificate

RUN apt-get install xz-utils -y
                
RUN cd /home && for f in *.tar*; do tar xf $f; done

RUN mkdir /home/binutils-build && cd /home/binutils-build && ../binutils*/configure  --prefix=$PREFIX --target=$ARCH --disable-multilib && make -j4 && make install
RUN cd /home/linux* && make ARCH=$KERNELARCH INSTALL_HDR_PATH=$PREFIX/$ARCH headers_install

ENV PATH="/home/cross/bin:${PATH}"

RUN cd /home/glibc-* && mkdir /home/glibc-build && cd /home/glibc-build && ../glibc-*/configure --prefix=$PREFIX/$ARCH --build=$MACHTYPE --host=$ARCH --target=$ARCH --with-headers=$PREFIX/$ARCH/include --disable-multilib libc_cv_forced_unwind=yes CC='gcc -U__i686' CFLAGS="-U_FORTIFY_SOURCE -O2 -fno-stack-protector" && make install-bootstrap-headers=yes install-headers && make -j4 && make install

RUN cd /home/gcc* && ln -s ../mpfr-$MPFRVER mpfr && \
                     ln -s ../gmp-$GMPVER gmp && \
		     ln -s ../mpc-$MPCVER mpc && \
		     ln -s ../isl-$ISLVER isl && \
		     ln -s ../cloog-$CLOOGVER cloog

RUN cd /home/gcc* && sed -i s/PATH_MAX/4096/ libmpx/mpxrt/mpxrt-utils.c
RUN mkdir /home/gcc-build && cd /home/gcc-build && ../gcc*/configure --prefix=$PREFIX --target=$ARCH --enable-languages=c,c++ --disable-multilib && make -j4 && make install


RUN apt-get remove g++ -y
