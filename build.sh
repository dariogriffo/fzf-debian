FZF_VERSION=$1
BUILD_VERSION=$2
declare -a arr=("bookworm" "trixie" "sid")
for i in "${arr[@]}"
do
  DEBIAN_DIST=$i
  FULL_VERSION=$FZF_VERSION-${BUILD_VERSION}+${DEBIAN_DIST}_amd64
docker build . -t fzf-$DEBIAN_DIST  --build-arg DEBIAN_DIST=$DEBIAN_DIST --build-arg FZF_VERSION=$FZF_VERSION --build-arg BUILD_VERSION=$BUILD_VERSION --build-arg FULL_VERSION=$FULL_VERSION
  id="$(docker create fzf-$DEBIAN_DIST)"
  docker cp $id:/fzf_$FULL_VERSION.deb - > ./fzf_$FULL_VERSION.deb
  tar -xf ./fzf_$FULL_VERSION.deb
done


