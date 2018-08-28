#!/bin/sh


if [ "$TAR_PATH" = "" ]; then


    _file="$TAR_TO_RESTORE"

else
    echo "Getting latest filename"
    aws configure set aws_access_key_id $S3_KEY
    aws configure set aws_secret_access_key $S3_SECRET
    filename=`aws  --endpoint-url $S3_PROTOCOL://$S3_HOST/ s3 ls s3://$S3_BUCKET/$TAR_PATH/ | sort | tail -n 1 | awk '{print $4}'`
    echo $filename
    _file="$TAR_PATH/$filename"
fi



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

if [ "$TRANSFORM_FROM" = "" ]; then

    tar -xvf  out.tar.gz -C /

else

    tar -xvf  out.tar.gz -C /
    rsync -avh $TRANSFORM_FROM $TRANSFORM_TO --delete
    rm -rf $TRANSFORM_FROM

fi

rm out.tar.gz
