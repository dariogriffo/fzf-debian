ARG DEBIAN_DIST=bookworm
FROM debian:$DEBIAN_DIST

ARG DEBIAN_DIST
ARG FZF_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION

RUN apt update && apt install -y wget
RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/fzf
RUN cd /output/usr/bin && wget https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz && tar -xf fzf-${FZF_VERSION}-linux_amd64.tar.gz && rm -f fzf-${FZF_VERSION}-linux_amd64.tar.gz 
RUN mkdir -p /output/DEBIAN
COPY output/DEBIAN/control /output/DEBIAN/
COPY output/copyright /output/usr/share/doc/fzf/
COPY output/changelog.Debian /output/usr/share/doc/fzf/
COPY output/README.md /output/usr/share/doc/fzf/

RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/usr/share/doc/fzf/changelog.Debian
RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/fzf/changelog.Debian
RUN sed -i "s/DIST/$DEBIAN_DIST/" /output/DEBIAN/control
RUN sed -i "s/FZF_VERSION/$FZF_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control

RUN dpkg-deb --build /output /fzf_${FULL_VERSION}.deb


