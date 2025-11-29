FROM python:3.10-slim

WORKDIR /app

# Correct OpenCV dependencies for Debian Trixie (Railway)
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of your app
COPY . .

EXPOSE 8501

CMD ["sh", "-c", "streamlit run app.py --server.address=0.0.0.0 --server.port=${PORT:-8501}"]
