# Stage 1: Build Stage
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} as builder

WORKDIR /app
COPY . .

# Stage 2: Run Stage
FROM python:${PYTHON_VERSION} as run
WORKDIR /app

# ENV for database
ENV PYTHONUNBUFFERED=1
ENV ENGINE=django.db.backends.mysql
ENV NAME=app_db
ENV USER=app_user
ENV PASSWORD=1234
ENV HOST=mysql
ENV PORT=3306

COPY --from=builder /app .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8080"]
