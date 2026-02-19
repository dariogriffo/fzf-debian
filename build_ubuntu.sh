FZF_VERSION=$1
BUILD_VERSION=$2
declare -a arr=("jammy" "noble" "questing")
for i in "${arr[@]}"
do
  UBUNTU_DIST=$i
  FULL_VERSION=$FZF_VERSION-${BUILD_VERSION}+${UBUNTU_DIST}_amd64_ubu
  docker build . -f Dockerfile.ubu -t fzf-ubuntu-$UBUNTU_DIST --build-arg UBUNTU_DIST=$UBUNTU_DIST --build-arg FZF_VERSION=$FZF_VERSION --build-arg BUILD_VERSION=$BUILD_VERSION --build-arg FULL_VERSION=$FULL_VERSION
  id="$(docker create fzf-ubuntu-$UBUNTU_DIST)"
  docker cp $id:/fzf_$FULL_VERSION.deb - > ./fzf_$FULL_VERSION.deb
  tar -xf ./fzf_$FULL_VERSION.deb
done
