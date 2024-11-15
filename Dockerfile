ARG INTERMEDIATE_IMAGE_ALICE \
    INTERMEDIATE_IMAGE_BOB \
    INTERMEDIATE_IMAGE_CHARLIE

# -------------------
FROM busybox AS build

ARG FIRST_NAME

RUN test -n "$FIRST_NAME" || exit 1

RUN mkdir --parents /usr/local/bin \
    && FIRST_NAME_LOWER=$(echo $FIRST_NAME | tr [:upper:] [:lower:]) \
    && echo "#!/bin/sh" >> "/usr/local/bin/hello-$FIRST_NAME_LOWER" \
    && echo "echo Hello, $FIRST_NAME" >> "/usr/local/bin/hello-$FIRST_NAME_LOWER" \
    && chmod +x "/usr/local/bin/hello-$FIRST_NAME_LOWER"

# -----------------------------------------------
FROM ${INTERMEDIATE_IMAGE_ALICE} AS stage-alice
FROM ${INTERMEDIATE_IMAGE_BOB} AS stage-bob
FROM ${INTERMEDIATE_IMAGE_CHARLIE} AS stage-charlie

# ---------------------
FROM busybox AS combine

COPY --from=stage-alice /usr/local /usr/local
COPY --from=stage-bob /usr/local /usr/local
COPY --from=stage-charlie /usr/local /usr/local
