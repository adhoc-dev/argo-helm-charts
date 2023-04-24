#!/bin/bash

# Setear ARGOCD_USER, ARGOCD_PASSWORD, DOCKERHUB_USER, DOCKERHUB_TOKEN, SMTP

ARGOCD_URL=""
ARGOCD_USER=""
ARGOCD_PASSWORD=""

# Helm chart
REPOSITORY_URL=""

# Docker HUB
DOCKERHUB_USER=""
DOCKERHUB_TOKEN=""

echo "##########################"
echo "# ArgoCD Deployment tool #"
echo "#        Adhoc           #"
echo "##########################"

echo ""
echo "ArogCD URL: $ARGOCD_URL"

# Password Input
echo -n ArgoCD password: 
read -s ARGOCD_PASSWORD ; echo

# Login
if argocd login $ARGOCD_URL --username=$ARGOCD_USER --password=$ARGOCD_PASSWORD --grpc-web; then
    echo "Logged in"
else
    echo "Error trying to login"
fi

# dockerhub connection string
dockerhub_pull_secret=$(echo -n "{\"auths\":{\"docker.io\":{\"auth\":\"`echo -n "$DOCKERHUB_USER:$DOCKERHUB_TOKEN"|base64`\"}}}"|base64 -w 0)

# Onboard
read -p "¿Onboard new client? - y/n: " RES

while [ $RES != 'n' ]
do
    read -p "Client name: " CLIENT_NAME
    echo $CLIENT_NAME

    argocd app create $CLIENT_NAME --repo "$REPOSITORY_URL" --helm-chart "adhoc-odoo" --revision "0.2.2" --dest-namespace "$CLIENT_NAME" --dest-server "https://kubernetes.default.svc" --project "default" --helm-set dockerhubPullSecret=$dockerhub_pull_secret --helm-set SMTP_USER="postmaster@mg.adhoc.ar" --helm-set SMTP_PASSWORD="" --helm-set SMTP_SSL="true" --helm-set SERVER_MODE="test" --helm-set AEROO_DOCS_HOST="adhoc-aeroo-docs.adhoc-aeroo-docs.svc.cluster.local"
    argocd app sync $CLIENT_NAME

    read -p "¿Onboard new client? - y/n: " RES
done

read -p "Update client? - y/n: " RES

while [ $RES != 'n' ]
do
    read -p "Client name: " CLIENT_NAME
    echo $CLIENT_NAME

    argocd app set $CLIENT_NAME -p odoo.smtp.user="" -p odoo.smtp.pass="" -p odoo.smtp.ssl="true" -p odoo.saas.mode="test" -p odoo.basic.aerooHost="adhoc-aeroo-docs.adhoc-aeroo-docs.svc.cluster.local"
    argocd app sync $CLIENT_NAME
done
