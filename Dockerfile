# Start from a compatible base image
FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    libgcc-s1 \
    wget \
    supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy necessary files into the /app directory
COPY config.yaml start.sh verifier libdarwin_verifier.so librsp.so /app/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Ensure the verifier and start.sh are executable
RUN chmod +x /app/start.sh /app/verifier

# Set environment variables for library paths and other parameters
ENV LD_LIBRARY_PATH=/app
ENV CHAIN_ID=534352

# Use supervisord as the entry point
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

