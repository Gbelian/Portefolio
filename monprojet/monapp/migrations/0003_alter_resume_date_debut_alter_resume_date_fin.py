# Generated by Django 5.0.6 on 2024-05-13 23:43

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('monapp', '0002_category_project_skill_post_comment'),
    ]

    operations = [
        migrations.AlterField(
            model_name='resume',
            name='date_debut',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='resume',
            name='date_fin',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]
