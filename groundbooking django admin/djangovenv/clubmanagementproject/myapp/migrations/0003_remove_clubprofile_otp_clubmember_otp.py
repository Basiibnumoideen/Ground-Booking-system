# Generated by Django 5.0.2 on 2024-03-05 09:57

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0002_clubprofile_otp'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='clubprofile',
            name='otp',
        ),
        migrations.AddField(
            model_name='clubmember',
            name='otp',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
    ]
