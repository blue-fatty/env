# https://github.com/jhpoelen/zenodo-upload
# https://developers.zenodo.org/#quickstart-upload
DEPOSITION=$1
FILEPATH=$2
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

BUCKET=$(curl -H "Accept: application/json" -H "Authorization: Bearer $ZENODO_TOKEN" "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION" | jq --raw-output .links.bucket)


curl --progress-bar -o /dev/null --upload-file $FILEPATH $BUCKET/$FILENAME?access_token=$ZENODO_TOKEN
