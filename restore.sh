#!/bin/sh

_file="$TAR_TO_RESTORE"

bucket="$S3_BUCKET"

host="$S3_HOST"
link="$S3_PROTOCOL""://""$S3_HOST"

echo "$link"

s3_key="$S3_KEY"
s3_secret="$S3_SECRET"

resource="/${bucket}/${_file}"
content_type="application/octet-stream"
date=`date -R`
_signature="GET\n\n${content_type}\n${date}\n${resource}"
signature=`echo -en ${_signature} | openssl sha1 -hmac ${s3_secret} -binary | base64`
echo $signature
echo "Download file $link${resource}"
curl -v -H "Host: $host" \
-H "Date: ${date}" \
-H "Content-Type: ${content_type}" \
-H "Authorization: AWS ${s3_key}:${signature}" \
$link${resource} -o out.tar.gz
echo "SUBSTITUTING FILES!!!"
tar -xvf  out.tar.gz -C /
rm out.tar.gz
