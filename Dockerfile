FROM lpenz/debian-etch-amd64

WORKDIR /tmp

RUN apt-get update && apt-get install -y build-essential ghc bzip2 libcurl3-dev

COPY FreeArc-0.51-sources.tar.bz2 .

RUN tar --no-same-owner -xf FreeArc-0.51-sources.tar.bz2 && cd FreeArc-0.51-sources && \
    find . -type f -name makefile -print0 | xargs -0 sed -i 's/-march=i486 -mtune=pentiumpro//g' && \
    sed -i 's/-fno-rtti/-fno-rtti -fpermissive/' Compression/Tornado/makefile && \
    sed -i 's/stdcall unsafe "pthread\.h/ccall unsafe "pthread.h/' Files.hs && \ 
    (cd HsLua && ghc --make Setup.hs && ./Setup configure && ./Setup build && ./Setup install) && \
    ./compile-O2 && \
    make clean && \
    cp Tests/arc /usr/local/bin/arc
    
