#!/usr/bin/env bash

set -e

echo "Building literalgarage.com:"
rm -rf dist/
npm run build
rm -f _site/deploy.sh

echo "Syncing S3 bucket:"
aws s3 sync dist/ s3://literalgarage.com --delete --acl public-read "$@" --profile literal-garage-web

echo "Invalidating CloudFront distribution:"
aws cloudfront create-invalidation --distribution-id E1P44WZPV25YC6 --profile literal-garage-web --paths "/*" "$@"
