FROM busybox AS build

ARG FIRST_NAME

RUN test -n "$FIRST_NAME" || exit 1

RUN mkdir --parents /usr/local/bin \
    && FIRST_NAME_LOWER=$(echo $FIRST_NAME | tr [:upper:] [:lower:]) \
    && echo "#!/bin/sh" >> "/usr/local/bin/hello-$FIRST_NAME_LOWER" \
    && echo "echo Hello, $FIRST_NAME" >> "/usr/local/bin/hello-$FIRST_NAME_LOWER" \
    && chmod +x "/usr/local/bin/hello-$FIRST_NAME_LOWER"

CMD [ "ls", "/usr/local/bin"]
