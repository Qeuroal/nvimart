.PHONY: install uninstall clean rmvim \
	gm gitmerge

install:
	@bash scripts/install.sh

local:
	@bash scripts/local_install.sh

uninstall:
	@bash scripts/uninstall.sh

clean:
	@yes y | bash scripts/uninstall.sh
	@if [ -e ./vimart_envs  ]; then rm -i ./vimart_envs; fi

rmvim:
	@sudo make uninstall -C ~/.vimsrc
	@sudo rm -rf /usr/local/share/vim/vim91
	@sudo rm -f /usr/local/bin/eview
	@sudo rm -f /usr/local/bin/evim
	@sudo rm -f /usr/local/bin/ex
	@sudo rm -f /usr/local/bin/gview
	@sudo rm -f /usr/local/bin/gvim
	@sudo rm -f /usr/local/bin/gvim
	@sudo rm -f /usr/local/bin/gvimdiff
	@sudo rm -f /usr/local/bin/rgview
	@sudo rm -f /usr/local/bin/rgvim
	@sudo rm -f /usr/local/bin/rview
	@sudo rm -f /usr/local/bin/rvim
	@sudo rm -f /usr/local/bin/rvim
	@sudo rm -f /usr/local/bin/view
	@sudo rm -f /usr/local/bin/vim
	@sudo rm -f /usr/local/bin/vimdiff
	@sudo rm -f /usr/local/bin/vimtutor
	@sudo rm -f /usr/local/bin/xxd
	@sudo rm -f /usr/local/man/man1/eview.1
	@sudo rm -f /usr/local/man/man1/evim.1
	@sudo rm -f /usr/local/man/man1/ex.1
	@sudo rm -f /usr/local/man/man1/gview.1
	@sudo rm -f /usr/local/man/man1/gvim.1
	@sudo rm -f /usr/local/man/man1/gvimdiff.1
	@sudo rm -f /usr/local/man/man1/rgview.1
	@sudo rm -f /usr/local/man/man1/rgvim.1
	@sudo rm -f /usr/local/man/man1/rview.1
	@sudo rm -f /usr/local/man/man1/rvim.1
	@sudo rm -f /usr/local/man/man1/view.1
	@sudo rm -f /usr/local/man/man1/vim.1
	@sudo rm -f /usr/local/man/man1/vimdiff.1
	@sudo rm -f /usr/local/man/man1/vimtutor.1
	@sudo rm -f /usr/local/man/man1/xxd.1

gm gitmerge:
	@git switch master && git merge --no-ff -m "merge dev" dev && git push && git switch dev


