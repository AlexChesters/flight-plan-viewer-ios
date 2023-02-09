set -euo pipefail

ARCHIVE_PATH=$1
TMP_BUILD_DIR_PATH="/tmp/flight-plan-viewer-$(date +"%Y-%m-%dT%H_%M_%S")"

echo "[INFO] converting $ARCHIVE_PATH to .ipa"

mkdir -p $TMP_BUILD_DIR_PATH/Payload

pushd $ARCHIVE_PATH

cp -R Products/Applications/flight-plan-viewer.app $TMP_BUILD_DIR_PATH/Payload

popd

pushd $TMP_BUILD_DIR_PATH
zip -r fpv.zip .
mv fpv.zip ~/Desktop/fpv.ipa
popd
