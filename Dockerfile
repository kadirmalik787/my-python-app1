# Stage 1 - Build stage (sirf build ke liye)
FROM python:3.11-slim as builder

WORKDIR /app
COPY requirements.txt .

# Virtual environment create karo
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Dependencies install karo
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 - Runtime stage (final lightweight image)
FROM python:3.11-slim

WORKDIR /app

# Virtual environment copy karo builder se
COPY --from=builder /opt/venv /opt/venv

# App code copy karo
COPY . .

# Environment setup
ENV PATH="/opt/venv/bin:$PATH"
EXPOSE 8079

CMD ["python", "app.py"]
