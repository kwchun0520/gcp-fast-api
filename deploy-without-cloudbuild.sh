#usr/bin/env bash
set -x

PROJECT_ID=$1
ARTIFECT_REGISTRY=$2
IMAGE_NAME=$3
TAG=$4

gcloud auth configure-docker us-central1-docker.pkg.dev

docker build -t us-central1-docker.pkg.dev/$PROJECT_ID/$ARTIFECT_REGISTRY/$IMAGE_NAME:$TAG .

docker push us-central1-docker.pkg.dev/$PROJECT_ID/$ARTIFECT_REGISTRY/$IMAGE_NAME:$TAG

gcloud run deploy fast-api \
    --image us-central1-docker.pkg.dev/$PROJECT_ID/$ARTIFECT_REGISTRY/$IMAGE_NAME:$TAG \
    --platform managed \
    --region us-central1 \
    --cpu 1 \
    --memory 256Mi \
    --set-env-vars 'ENV=prod, VAR=1' \
    --port 8080 
    # --env-vars-file 'deployment/app.yaml'