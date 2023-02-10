set -euo pipefail

rm -rf build/

xcodebuild \
  -project flight-plan-viewer/flight-plan-viewer.xcodeproj \
  -scheme flight-plan-viewer \
  -archivePath flight-plan-viewer.xcarchive archive \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO

TMP_BUILD_DIR_PATH="/tmp/flight-plan-viewer-$(date +"%Y-%m-%dT%H_%M_%S")"

echo "[INFO] converting archive to .ipa"

mkdir -p build/Payload

pushd flight-plan-viewer.xcarchive

cp -R Products/Applications/flight-plan-viewer.app ../build/Payload

popd

pushd build
zip -r fpv.zip .
mv fpv.zip ../fpv.ipa
popd
