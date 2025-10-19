# Stage 1: Build Stage
ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION} as builder

# Set the working directory
WORKDIR /app
COPY . .

# Stage 2: Run Stage
FROM python:${PYTHON_VERSION} as run

WORKDIR /app


# ENV for database
ENV PYTHONUNBUFFERED=1
ENV DB_ENGINE=mysql.connector.django
ENV DB_NAME=app_db
ENV DB_USER=app_user
ENV DB_PASSWORD=1234
ENV DB_HOST=mysql
ENV DB_PORT=3306


COPY --from=builder /app .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

EXPOSE 8080

# Run database migrations and start the Django application
ENTRYPOINT ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8080"]