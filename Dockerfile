
FROM alpine:latest
RUN apk update && apk add git openssh
COPY id_rsa /root/.ssh/id_rsa


RUN chmod 400 /root/.ssh/id_rsa


RUN mkdir /app
WORKDIR /app

# Klonowanie repozytorium z wykorzystaniem protokołu SSH
RUN git clone git@github.com:szymer1414/TechChmur_lab5.git .

# Budowa obrazu
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/app/.cache \
    --mount=type=cache,target=/app/vendor \
    --mount=type=ssh \
    --frontend=ssh \
    --local context=. \
    --local dockerfile=. \
    --output type=image,name=docker.io/szymer1414/lab6:v1 \
    build

LABEL lab6="buildkit"

CMD ["echo", "Sukces"]
