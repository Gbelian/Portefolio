#!/usr/bin/env bash
# exit on error
set -o errexit

python -m pip install --upgrade pip

pip install -r requirements.txt

#python manage.py collectstatic --no-input
python manage.py migrate

# Créez un superutilisateur (admin)
echo "from django.contrib.auth.models import User; User.objects.create_superuser('beninbmcn', 'BMCN.UAC@gmail.com', 'beninbmcn')" | python manage.py shell

# Lancez le serveur Gunicorn
gunicorn JSSNUTRITION.wsgi:application