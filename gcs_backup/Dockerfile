FROM python:3.12.7-slim

COPY requirements.txt requirements.lock ./
RUN pip install -r requirements.txt -c requirements.lock
CMD ["python", "gcs_backup.py"]
