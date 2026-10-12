FROM python:3.11-slim

# ffmpeg is required by pydub to decode mp3/ogg
RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY static ./static
COPY templates ./templates

# app reads audio from /opt/audio and reads/writes CSVs in /opt/data
RUN mkdir -p /opt/audio /opt/data
VOLUME ["/opt/audio", "/opt/data"]

EXPOSE 8000

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
