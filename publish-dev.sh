#!/usr/bin/env bash
set -e

bucketname=dev-sdk-build-artifacts
rootDir=`pwd`
filename=$1-$(date +%Y%m%d-%H%M%S).tar.gz
packageDir=packages/$1
yarn build
mkdir -p publish-dev-dist/dist
mkdir -p publish-dev-dist/lib
mkdir -p publish-dev-dist/styles
cp -r dist/* publish-dev-dist/dist
cp -r lib/* publish-dev-dist/lib
cp -r styles/* publish-dev-dist/styles
cp package.json publish-dev-dist/package.json

cd publish-dev-dist
tar czf $rootDir/$filename ./*
cd ..
rm -rf ./publish-dev-dist
cd $rootDir

aws s3api put-object --bucket $bucketname --key $filename --body $filename --profile veritone
rm $filename
echo "Artifact stored at https://${bucketname}.s3.amazonaws.com/${filename}"