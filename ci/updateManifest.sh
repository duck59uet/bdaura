#!/bin/sh
set -xe

apk add bash && apk add git && apk add --update curl && rm -rf /var/cache/apk/*

# clone repo manifest
git clone "https://${PERSONAL_ACCESS_TOKEN}@${REPO_MANIFEST_URL}"
cd ./${REPO_MANIFEST_NAME}
git checkout ${REPO_MANIFEST_BRANCH} && git pull

if [ ${GITHUB_REF_NAME} = "develop" ]
then
  echo 'This is dev branch'
  cd ${REPO_MANIFEST_ENV_DEV}
elif [ ${GITHUB_REF_NAME} = "serenity" ]
then
  echo 'This is serenity branch'
  cd ${REPO_MANIFEST_ENV_SERENITY}
elif [ ${GITHUB_REF_NAME} = "main" ]
then
  echo 'This is main branch'
  cd ${REPO_MANIFEST_ENV_MAIN}
else
  exit
fi

# kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
  ./kustomize edit set image image_bdaura_aurad=ghcr.io/aura-nw/bdaura-aurad:${GITHUB_REF_NAME}_${COMMIT_TAG}
  ./kustomize edit set image image_bdaura_hasura=hasura/graphql-engine:v2.0.4
  rm kustomize

git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "user@aura.network"
git add .
git commit -m "Update image to bdaura"
git push