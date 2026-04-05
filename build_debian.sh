FZF_VERSION=$1
BUILD_VERSION=$2
declare -a distros=("forky")

declare -A arch_map=(
  ["amd64"]="linux_amd64"
  ["arm64"]="linux_arm64"
  ["armel"]="linux_armv5"
  ["armhf"]="linux_armv7"
  ["ppc64el"]="linux_ppc64le"
  ["s390x"]="linux_s390x"
  ["riscv64"]="linux_riscv64"
  ["loong64"]="linux_loong64"
)

for DEBIAN_DIST in "${distros[@]}"
do
  for DEB_ARCH in "${!arch_map[@]}"
  do
    FZF_ARCH="${arch_map[$DEB_ARCH]}"
    FULL_VERSION=$FZF_VERSION-${BUILD_VERSION}+${DEBIAN_DIST}_${DEB_ARCH}

    wget https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-${FZF_ARCH}.tar.gz
    tar -xf fzf-${FZF_VERSION}-${FZF_ARCH}.tar.gz
    rm -f fzf-${FZF_VERSION}-${FZF_ARCH}.tar.gz

    docker build . -t fzf-${DEBIAN_DIST}-${DEB_ARCH} \
      --build-arg DEBIAN_DIST=$DEBIAN_DIST \
      --build-arg FZF_VERSION=$FZF_VERSION \
      --build-arg BUILD_VERSION=$BUILD_VERSION \
      --build-arg FULL_VERSION=$FULL_VERSION \
      --build-arg DEB_ARCH=$DEB_ARCH
    id="$(docker create fzf-${DEBIAN_DIST}-${DEB_ARCH})"
    docker cp $id:/fzf_$FULL_VERSION.deb - > ./fzf_$FULL_VERSION.deb
    tar -xf ./fzf_$FULL_VERSION.deb

    rm -f fzf
  done
done
