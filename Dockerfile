FROM python:3.9-slim

WORKDIR /taiga-back

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gettext \
    && rm -rf /var/lib/apt/lists/*

COPY . /taiga-back/

RUN pip install --upgrade pip \
    && pip install -r requirements.txt \
    && pip install psycopg2-binary

RUN python manage.py collectstatic --noinput
RUN python manage.py compilemessages

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && gunicorn -b 0.0.0.0:8000 taiga.wsgi"]
