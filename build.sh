#!/usr/bin/env bash

#cd ..

env=${SET_ENV}
des=${DES}

# shellcheck disable=SC2034
app="app"
version="$(cat pubspec.yaml | shyaml get-value version)"

# shellcheck disable=SC2034
# shellcheck disable=SC2006
# shellcheck disable=SC2002
flutter_version=$(cat .fvm/fvm_config.json | jq -r '.flutterSdkVersion')


echo "${des}===android====${env}"
echo "清理 build"
# shellcheck disable=SC2038
find . -d -name "build" | xargs rm -rf

#fvm use "${flutter_version}" --force
fvm install "${flutter_version}"
fvm use "${flutter_version}"


fvm flutter clean
mkdir -p app
apk_path=app/android-${env}

if [ ! -d "$apk_path" ]; then
  rm -rf $apk_path
  mkdir -p $apk_path
else
  rm -rf $apk_path
  mkdir -p $apk_path
  echo dir exist
fi

echo "flutter packages get...."
fvm flutter packages get

echo "build package...."
fvm flutter build apk -t lib/main_"${env}".dart --no-tree-shake-icons --release --flavor "${env}" #--no-codesign
echo "build package successed"

cp -r build/app/outputs/apk/"${env}"/release/app-"${env}"-release.apk ${apk_path}
mv ${apk_path}/app-"${env}"-release.apk "${apk_path}"/v${version}-"${env}".apk



