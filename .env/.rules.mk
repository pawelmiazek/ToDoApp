BLDDIR=$(shell pwd)
PRJDIR=$(shell dirname ${BLDDIR})
TOPDIR=$(shell dirname ${PRJDIR})
LOGDIR=$(TOPDIR)/logs
RUNDIR=$(TOPDIR)/run
NODEDIR=$(TOPDIR)/node
LIBDIR=$(PYDIR)/lib
UNAME=$(shell uname)
BRANCH=$(shell git branch 2>/dev/null | grep '^*' | colrm 1 2)
PATH=$(NODEDIR)/bin:$(PRJDIR)/bin:/bin:/usr/bin


all:   done.dirs done.node done.pre

clean:
	rm -f done.*

distclean: clean
	rm -rf node-*


dirs: done.dirs
pre: done.pre
node: done.node

done.pre:
	@for f in `find .. -name "*.++"`; do  \
		n=`echo $$f | sed "s/.++$$//g"`; \
		echo "$$f => $$n"; \
		if [ -f $$n ] ; then mv $$n $$n.old ; fi; \
		cat $$f \
			| sed "s@++TOPDIR++@$(TOPDIR)@g" \
			| sed "s@++NODEDIR++@$(NODEDIR)@g" \
			| sed "s@++LIBDIR++@$(LIBDIR)@g" \
			| sed "s@++LOGDIR++@$(LOGDIR)@g" \
			| sed "s@++RUNDIR++@$(RUNDIR)@g" \
			| sed "s@++PRJDIR++@$(PRJDIR)@g" \
			| sed "s@++USER++@$(USER)@g" \
			| sed "s@++GROUP++@$(GROUP)@g" \
			| sed "s:++EMAIL++:$(EMAIL):g" \
			| sed "s@++DOMAIN++@$(DOMAIN)@g" \
			| sed "s@++PORT++@$(PORT)@g" \
			| sed "s@++VERSION++@$(VERSION)@g" \
			| sed "s@++BRANCH++@$(BRANCH)@g" \
			> $$n ; \
		chmod 755 $$n ; \
	done
	touch $@

node-v${nodeversion}-linux-x64.tar.xz:
	wget https://nodejs.org/dist/v${nodeversion}/node-v${nodeversion}-linux-x64.tar.xz
	touch $@

node-v${nodeversion}-linux-x64: node-v${nodeversion}-linux-x64.tar.xz
	tar xf $<
	touch $@

done.node: node-v${nodeversion}-linux-x64
	@if [ -d ${NODEDIR} ] ; then echo "*** Directory ${NODEDIR} exists. Remove it first.";exit 1;fi
	cp -r $< ${NODEDIR}
	${NODEDIR}/bin/npm install -g npm
	${NODEDIR}/bin/npm install -g yarn
	touch $@

done.dirs:
	mkdir -p ${LOGDIR}
	mkdir -p ${RUNDIR}
	touch $@