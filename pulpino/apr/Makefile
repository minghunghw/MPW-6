all: apr


.PHONY: help
help:
	@echo 'Usage: make [target] ...                                              '
	@echo '                                                                      '
	@echo '  help        Show this help.                                         '
	@echo '  apr         APR with Innovus.                                       '
	@echo '  clean       Remove all the log files.                               '


.PHONY: apr
apr:
	mkdir -p run && cd run && \
	innovus -init ../apr.tcl | tee ../apr.log


.PHONY: apr_mem
apr_mem:
	mkdir -p run && cd run && \
	innovus -64 -init ../apr_mem.tcl | tee ../apr_mem.log


.PHONY: apr_core
apr_core:
	mkdir -p run && cd run && \
	innovus -64 -init ../apr_core.tcl | tee ../apr_core.log


.PHONY: clean
clean:
	rm -f run/*.log
	rm -f run/*.log1
	rm -f run/*.logv
	rm -f run/*.logv1
