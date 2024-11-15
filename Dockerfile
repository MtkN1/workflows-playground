FROM buildpack-deps:bookworm AS source

ENV PATH /usr/local/bin:$PATH

ENV GPG_KEY 7169605F62C751356D054A26A821E680E5FA6305
ENV PYTHON_VERSION 3.13.0
ENV PYTHON_SHA256 086de5882e3cb310d4dca48457522e2e48018ecd43da9cdf827f6a0759efb07d

RUN set -eux; \
	\
	wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; \
	echo "$PYTHON_SHA256 *python.tar.xz" | sha256sum -c -; \
	wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"; \
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; \
	gpg --batch --verify python.tar.xz.asc python.tar.xz; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" python.tar.xz.asc; \
	mkdir -p /usr/src/python; \
	tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
	rm python.tar.xz

# ------------------------------------------------------------------------------

FROM source AS configure

RUN set -eux; \
	\
	cd /usr/src/python; \
	./configure --with-ensurepip=no

# ------------------------------------------------------------------------------

FROM configure AS make

RUN set -eux; \
	\
	cd /usr/src/python; \
	make -j

# ------------------------------------------------------------------------------

FROM make AS make-install

RUN set -eux; \
	\
	cd /usr/src/python; \
	make altinstall
