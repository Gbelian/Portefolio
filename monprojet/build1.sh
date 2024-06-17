#!/usr/bin/env bash
# exit on error
set -o errexit

# Mettre à jour pip et installer les dépendances
python -m pip install --upgrade pip
pip install -r requirements.txt

# Configurer et démarrer MinIO Server avec des identifiants par défaut
wget https://dl.min.io/server/minio/release/linux-amd64/minio -O /usr/local/bin/minio
chmod +x /usr/local/bin/minio
export MINIO_ACCESS_KEY=minioadmin
export MINIO_SECRET_KEY=minioadmin
nohup minio server /data &

# Télécharger et configurer MinIO Client (mc) avec les mêmes identifiants
wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc
chmod +x /usr/local/bin/mc
mc alias set myminio http://localhost:9000 minioadmin minioadmin
mc mb myminio/your-bucket-name

# Configuration de Django pour utiliser MinIO
cat <<EOL >> JSSNUTRITION/settings.py

# MinIO settings
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
AWS_ACCESS_KEY_ID = 'minioadmin'
AWS_SECRET_ACCESS_KEY = 'minioadmin'
AWS_STORAGE_BUCKET_NAME = 'your-bucket-name'
AWS_S3_ENDPOINT_URL = 'http://localhost:9000'
AWS_S3_REGION_NAME = 'us-east-1'
AWS_S3_SIGNATURE_VERSION = 's3v4'
AWS_S3_FILE_OVERWRITE = False
AWS_DEFAULT_ACL = 'public-read'
EOL

# Collecte des fichiers statiques et migrations
python manage.py collectstatic --no-input
python manage.py migrate

# Créez un superutilisateur (admin)
echo "from django.contrib.auth.models import User; User.objects.create_superuser('beninbmcn', 'BMCN.UAC@gmail.com', 'beninbmcn')" | python manage.py shell

# Lancez le serveur Gunicorn
gunicorn JSSNUTRITION.wsgi:application 