#!/usr/bin/env bash
# Scrapes the latest puphpet.zip file from puphpet.com.

DIR="$( cd -P "$( dirname "$0" )"/.. >/dev/null 2>&1 && pwd )"

SOURCE_URL="https://puphpet.com"
DEST_DIR="${DIR}/tmp"
DEST_FILE="puphpet.zip"
DEST_PATH="${DEST_DIR}/${DEST_FILE}"



# Do some sanity check of the current environment.
EXECUTABLES=("curl" "unzip" "git" "${DIR}/bin/formfind.pl")
for EXEC in "${EXECUTABLES[@]}"; do
	if ! command -v "${EXEC}" >/dev/null 2>&1; then
		echo "!! Required command \`${EXEC}\` was not found in PATH. Aborting."
		exit 1
	fi
done


# Scrape the ZIP from the source site.
echo "## Starting ZIP file scrape."

if [ ! -d "${DEST_DIR}" ]; then
	echo "## Creating missing destination folder \`${DEST_DIR}\`."
	mkdir -p "${DEST_DIR}"
fi

echo "## Submitted request to \`${DEST_DIR}\`."
# curl -L \ # @TODO: Re-enable.
#  --silent \
#  --output "${DEST_PATH}" \
#  --dump-header "${DIR}/tmp/request_headers.txt" \
#  --data 'vagrantfile-local[vm][box]=puphpet/debian75-x64' \ # We only need to POST a non-empty <form> to get the ZIP.
#  $SOURCE_URL

echo "## Done."

#exit 0  #@TODO: Testing





# Unpack the zip to our target folder, replacing the existing one if present.
SOURCE_ZIP="${DIR}/tmp/puphpet.zip"
TMP_UNZIP_DIR="${DIR}/tmp/unzip"
RELEASE_DIR="${DIR}/release"


if [ -f "${SOURCE_ZIP}" ]; then
	echo "## Removing existing destination dir \`${TMP_UNZIP_DIR}\`."
	rm -rf "${TMP_UNZIP_DIR}"
fi

echo "## Extracting temp archive \`${SOURCE_ZIP}\` to \`${TMP_UNZIP_DIR}\`."
unzip \
 -oqq \
 "${SOURCE_ZIP}" \
 -d "${TMP_UNZIP_DIR}"

# Get the random folder name inside the extracted folder.
RANDOM_SUB_DIR=$(cd -P "${TMP_UNZIP_DIR}" >/dev/null 2>&1; echo *)

mv -f "${TMP_UNZIP_DIR}/${RANDOM_SUB_DIR}" "${RELEASE_DIR}"



#exit 0   #@TODO: Testing




# Commit any and all changes to the release/ folder back into git.
# Use available local information to tag the commit for future identification.

GIT_COMMIT_MSG="Auto-release. `date`."

git add -A "${RELEASE_DIR}"

#git commit -m "${GIT_COMMIT_MSG}"







