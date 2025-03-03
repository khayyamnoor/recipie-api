import time
from django.core.management.base import BaseCommand
from psycopg2 import OperationalError as Psycopg2Error
from django.db.utils import OperationalError

class Command(BaseCommand):
    """Django command to wait for the database to be available before starting the app."""

    def handle(self, *args, **options):
        self.stdout.write("Waiting for database...")  # Log message
        db_ready = False
        while not db_ready:
            try:
                self.check(databases=["default"])  # Check if the DB is ready
                db_ready = True
            except (Psycopg2Error, OperationalError):
                self.stdout.write("Database unavailable, waiting 1 second...")
                time.sleep(1)

        self.stdout.write(self.style.SUCCESS("Database is ready! 🎉"))
