FROM python:3.10-slim

# Work directory inside the container
WORKDIR /app

# System deps for OpenCV etc.
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of your app (app.py, model/, etc.)
COPY . .

# Expose a port (actual port is given by $PORT from the host)
EXPOSE 8501

# Start Streamlit, binding to $PORT (Render / Railway set this env var)
CMD ["sh", "-c", "streamlit run app.py --server.address=0.0.0.0 --server.port=${PORT:-8501}"]
