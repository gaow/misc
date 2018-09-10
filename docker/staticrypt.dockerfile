# Docker container for StatiCrypt

FROM node:alpine
RUN apk add --no-cache bash
RUN npm install -g staticrypt

# Default command
CMD ["bash"]