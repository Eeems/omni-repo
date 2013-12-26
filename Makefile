pwd="$(shell pwd)"
user="eeems"
site="direct.eeems.ca"
site2="withg.org"
folder="/home/eeems/www/omni.eeems.ca/"
folder2="/home/eeems/public_html/omni/"

sshopt="-o LogLevel=error"
all: clean packages repo update clean
packages:
	@mkdir -p .repo/i686/
	@mkdir -p .repo/x86_64/
	@msg  -a "0;31"  -a "0;31" -m "Building Packages" -A ":::\t"
	 - @cat packages.list | while read pkg; do\
		cd $$pkg;\
		make;\
		cp -p *-i686.pkg.tar.xz $(pwd)/.repo/i686/;\
		cp -p *-x86_64.pkg.tar.xz $(pwd)/.repo/x86_64/;\
	done;
repo:
	@mkdir -p .repo/i686/
	@mkdir -p .repo/x86_64/
	@msg  -a "0;31"  -a "0;31" -m "Building Repo" -A ":::\t"
	@cd .repo/i686/;\
		repo-add omni.db.tar.gz *.xz;\
		rm -f omni.db
	@cd .repo/x86_64/;\
		repo-add omni.db.tar.gz *.xz;\
		rm -f omni.db
update:
	@cp -R skel/* .repo/
	@chown -R $(user) .repo/
	@chmod -R 0777 .repo/
	@msg  -a "0;31" -m "Uploading Files" -A ":::\t"
	-@ssh $(sshopt) $(user)@$(site) "cd $(folder)/;\
		rm -f i686/*;\
		rm -f x86_64/*;"
	-@ssh $(sshopt) $(user)@$(site2) "cd $(folder2)/;\
		rm -f i686/*;\
		rm -f x86_64/*;"
	@scp $(sshopt) -r .repo/* $(user)@$(site):$(folder)/
	@cp -R skel2/* .repo/
	@chown -R $(user) .repo/
	@chmod -R 0777 .repo/
	@scp $(sshopt) -r .repo/* $(user)@$(site2):$(folder2)/
	@ssh $(sshopt) $(user)@$(site) "cd $(folder);\
		chmod -R 0777 *;\
		cd $(folder)/i686;\
		rm -f omni.db;\
		link omni.db.tar.gz omni.db;\
		cd $(folder)/x86_64;\
		rm -f omni.db;\
		link omni.db.tar.gz omni.db";
	@ssh $(sshopt) $(user)@$(site2) "cd $(folder2);\
		chmod -R 0777 *;\
		cd $(folder2)/i686;\
		rm -f omni.db;\
		link omni.db.tar.gz omni.db;\
		cd $(folder2)/x86_64;\
		rm -f omni.db;\
		link omni.db.tar.gz omni.db";
clean:
	@msg  -a "0;31" -m "Removing all non-build files from $(pwd)" -A ":::\t"
	@rm ~/.makepkg.conf *.xz omni.db* -fv | awk '{print "\t",$$0}'
	@rm -rfv *~ | awk '{print "\t",$$0}'
	@rm .repo/ -rfv | awk '{print "\t",$$0}'
clean-all: clean
	@msg  -a "0;31"  -a "0;31" -m "Cleaning Project folders" -A ":::\t"
	 - @cat packages.list | while read pkg; do\
		cd $$pkg;\
		make clean;\
	done;
