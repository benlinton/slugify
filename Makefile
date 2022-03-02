prefix = /usr/local
man_prefix = $(prefix)/share

install:
	install -Dm755 slugify -t $(prefix)/bin
	gzip slugify.1
	install -Dm644 slugify.1.gz -t $(man_prefix)/man/man1

uninstall:
	rm -f $(prefix)/bin/slugify
	rm -f $(man_prefix)/man/man1/slugify.1.gz
