FROM busybox

RUN echo ::group::printenv \
    && printenv \
    && echo ::endgroup::
